from flask import Flask, render_template, flash, redirect, url_for, session, request, logging, jsonify
from flask_mysqldb import MySQL
from wtforms import Form, StringField, TextAreaField, PasswordField, validators, SelectField
from passlib.hash import sha256_crypt
from functools import wraps
from flask_uploads import UploadSet, configure_uploads, IMAGES
import timeit
import datetime
from flask_mail import Mail, Message
import os
import stripe
from wtforms.fields.html5 import EmailField

YOUR_DOMAIN = 'http://localhost:5000'
stripe.api_key = 'sk_test_51IZdK3SBnitWe2MbPPnpPYg5zSzXdxAfyizBZTEVZwvoFlX7HeGVmJqwV0jfWz6SNInzXJc7COOyVNiAcjmNNkCn00Eebtp27U'

app = Flask(__name__)
app.secret_key = os.urandom(24)
app.config['UPLOADED_PHOTOS_DEST'] = 'static/image/product'
photos = UploadSet('photos', IMAGES)
configure_uploads(app, photos)

mysql = MySQL()
app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'shoptubedb'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql.init_app(app)


def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, *kwargs)
        else:
            return redirect(url_for('login'))

    return wrap


def not_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return redirect(url_for('index'))
        else:
            return f(*args, *kwargs)

    return wrap


def is_admin_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'admin_logged_in' in session:
            return f(*args, *kwargs)
        else:
            return redirect(url_for('admin_login'))

    return wrap


def not_admin_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'admin_logged_in' in session:
            return redirect(url_for('admin'))
        else:
            return f(*args, *kwargs)

    return wrap


def wrappers(func, *args, **kwargs):
    def wrapped():
        return func(*args, **kwargs)

    return wrapped


def content_based_filtering(product_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM products WHERE id=%s", (product_id,))
    data = cur.fetchone()
    data_cat = data['category']
    print('Showing result for Product Id: ' + product_id)
    category_matched = cur.execute("SELECT * FROM products WHERE category=%s", (data_cat,))
    print('Total product matched: ' + str(category_matched))
    cat_product = cur.fetchall()
    cur.execute("SELECT * FROM product_level WHERE product_id=%s", (product_id,))
    id_level = cur.fetchone()
    recommend_id = []
    cate_level = ['v_shape', 'polo', 'clean_text', 'design', 'leather', 'color', 'formal', 'converse', 'loafer', 'hook',
                  'chain']
    for product_f in cat_product:
        cur.execute("SELECT * FROM product_level WHERE product_id=%s", (product_f['id'],))
        f_level = cur.fetchone()
        match_score = 0
        if f_level['product_id'] != int(product_id):
            for cat_level in cate_level:
                if f_level[cat_level] == id_level[cat_level]:
                    match_score += 1
            if match_score == 11:
                recommend_id.append(f_level['product_id'])
    print('Total recommendation found: ' + str(recommend_id))
    if recommend_id:
        cur = mysql.connection.cursor()
        placeholders = ','.join((str(n) for n in recommend_id))
        query = 'SELECT * FROM products WHERE id IN (%s)' % placeholders
        cur.execute(query)
        recommend_list = cur.fetchall()
        return recommend_list, recommend_id, category_matched, product_id
    else:
        return ''


@app.route('/')
def index():
    form = OrderForm(request.form)

    cur = mysql.connection.cursor()

    values = 'homecare'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY RAND() LIMIT 4", (values,))
    homecare = cur.fetchall()
    values = 'eggmeatfish'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY RAND() LIMIT 4", (values,))
    eggmeatfish = cur.fetchall()
    values = 'Bevearages'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY RAND() LIMIT 4", (values,))
    Bevearages = cur.fetchall()
    values = 'fruitsandvegitables'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY RAND() LIMIT 4", (values,))
    fruitsandvegitables = cur.fetchall()

    cur.close()
    return render_template('home.html', homecare=homecare, eggmeatfish=eggmeatfish, Bevearages=Bevearages, fruitsandvegitables=fruitsandvegitables, form=form)


class LoginForm(Form):
    username = StringField('', [validators.length(min=1)],
                           render_kw={'autofocus': True, 'placeholder': 'Username'})
    password = PasswordField('', [validators.length(min=3)],
                             render_kw={'placeholder': 'Password'})


@app.route('/login', methods=['GET', 'POST'])
@not_logged_in
def login():
    form = LoginForm(request.form)
    if request.method == 'POST' and form.validate():

        username = form.username.data

        password_candidate = form.password.data

        cur = mysql.connection.cursor()

        result = cur.execute("SELECT * FROM users WHERE username=%s", [username])

        if result > 0:

            data = cur.fetchone()
            password = data['password']
            uid = data['id']
            name = data['name']

            if sha256_crypt.verify(password_candidate, password):

                session['logged_in'] = True
                session['uid'] = uid
                session['s_name'] = name
                x = '1'
                cur.execute("UPDATE users SET online=%s WHERE id=%s", (x, uid))

                # return redirect(url_for('index'))
                if  'cat' in request.args:                
                    cat=request.args.get('cat', default = '*', type = str)
                    orderid=request.args.get('order',default='*',type=str)
                    return redirect(url_for(cat,order=orderid))
                else:
                    return redirect(url_for('index'))   

            else:
                flash('Incorrect password', 'danger')
                return render_template('login.html', form=form)

        else:
            flash('Username not found', 'danger')

            cur.close()
            return render_template('login.html', form=form)
    return render_template('login.html', form=form)


@app.route('/out')
def logout():
    if 'uid' in session:
        cur = mysql.connection.cursor()
        uid = session['uid']
        x = '0'
        cur.execute("UPDATE users SET online=%s WHERE id=%s", (x, uid))
        session.clear()
        flash('You are logged out', 'success')
        return redirect(url_for('index'))
    return redirect(url_for('login'))


class RegisterForm(Form):
    name = StringField('', [validators.length(min=3, max=50)],
                       render_kw={'autofocus': True, 'placeholder': 'Full Name'})
    username = StringField('', [validators.length(min=3, max=25)], render_kw={'placeholder': 'Username'})
    email = EmailField('', [validators.DataRequired(), validators.Email(), validators.length(min=4, max=25)],
                       render_kw={'placeholder': 'Email'})
    password = PasswordField('', [validators.length(min=3)],
                             render_kw={'placeholder': 'Password'})
    mobile = StringField('', [validators.length(min=11, max=15)], render_kw={'placeholder': 'Mobile'})
    order_place = StringField('', [validators.length(min=3, max=50)],
                              render_kw={'autofocus': True, 'placeholder': 'Order Place'})


@app.route('/register', methods=['GET', 'POST'])
@not_logged_in
def register():
    form = RegisterForm(request.form)
    if request.method == 'POST' and form.validate():
        name = form.name.data
        email = form.email.data
        username = form.username.data
        password = sha256_crypt.encrypt(str(form.password.data))
        mobile = form.mobile.data
        order_place = form.order_place.data

        # Create Cursor
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users(name, email, username, password, mobile,oplace) VALUES(%s, %s, %s, %s, %s,%s)",
                    (name, email, username, password, mobile, order_place))

        # Commit cursor
        mysql.connection.commit()

        # Close Connection
        cur.close()

        flash('You are now registered and can login', 'success')

        return redirect(url_for('login'))
    return render_template('register.html', form=form)


class MessageForm(Form):  # Create Message Form
    body = StringField('', [validators.length(min=1)], render_kw={'autofocus': True})


class OrderForm(Form):  # Create Order Form
    
    quantity = SelectField('', [validators.DataRequired()],
                           choices=[('1', '1'), ('2', '2'), ('3', '3'), ('4', '4'), ('5', '5')])
    



@app.route('/create-checkout-session', methods=['POST'])
def create_checkout_session():
    
        
    content= request.get_json(force = True)

    price=content['price']
    pid=content['pid']
    # mobile=content['mobile']
    # address=content['address']
    # name=content['name']
    quantity=content['quantity']
      
    
    try:
        checkout_session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[
                {
                    'price_data': {
                        'currency': 'inr',
                        'unit_amount': price,
                        'product_data': {
                            'name': 'Shirts',
                            'images': ['https://image.freepik.com/free-vector/premium-collection-badge-design-vector_53876-43821.jpg'],
                        },
                    },
                    'quantity': quantity,
                    
                },
            ],
            mode='payment',
            success_url=YOUR_DOMAIN+'/update?price={0}&pid={1}&quantity={2}'.format(price,pid,quantity),
            cancel_url=YOUR_DOMAIN+ '/cancel',
        )
        return jsonify({'id': checkout_session.id})
    except Exception as e:
        return jsonify(error=str(e)), 403

        
@app.route('/cancel', methods=['GET', 'POST'])    
def cancel():   
    return render_template('cancel.html')
@app.route('/update', methods=['GET', 'POST'])
def update():
    # quantity = form.quantity.data
    # pid = request.args['order']
    pid=request.args.get('pid', default = '*', type = str)
    quantity=request.args.get('quantity', default = '*', type = str)
    # values = 'tshirt'
    now = datetime.datetime.now()
    week = datetime.timedelta(days=7)
    delivery_date = now + week
    now_time = delivery_date.strftime("%y-%m-%d %H:%M:%S")

    curs = mysql.connection.cursor()
    if 'uid' in session:
        uid = session['uid']
        curs.execute("SELECT * FROM users WHERE id=%s", (uid,))
        data = curs.fetchone()
        ofname = data['name']
        mobile = data['mobile']
        order_place = data['oplace']
        curs.execute("SELECT * FROM products WHERE id=%s",(pid,))
        dataa = curs.fetchone()
        pname = dataa['pName']
        curs.execute("INSERT INTO orders(uid, pid, quantity, ddate, ofname, mobile, oplace,pname) "
                        "VALUES(%s, %s, %s, %s, %s, %s, %s, %s)",
                        (uid, pid, quantity, now_time, ofname, mobile, order_place, pname))
        curs.execute("SELECT * FROM products WHERE id=%s",(pid,))
        available=curs.fetchone()
        curs.execute("UPDATE products SET available=%s-%s WHERE id=%s",(available['available'],quantity, pid))
        

    else:
        flash('Login to continue', 'danger')
        return redirect(url_for('login'))

    mysql.connection.commit()

    curs.close()

    flash('Order successful', 'success')
    return render_template('success.html')

@app.route('/homecare', methods=['GET', 'POST'])
def homecare():
    form = OrderForm(request.form)

    cur = mysql.connection.cursor()

    values = 'homecare'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY id ASC", (values,))
    products = cur.fetchall()

    cur.close()

    if 'view' in request.args:
        product_id = request.args['view']
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (product_id,))
        product = curso.fetchall()
        x = content_based_filtering(product_id)
        wrappered = wrappers(content_based_filtering, product_id)
        execution_time = timeit.timeit(wrappered, number=0)

        if 'uid' in session:
            uid = session['uid']

            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM product_view WHERE user_id=%s AND product_id=%s", (uid, product_id))
            result = cur.fetchall()
            if result:
                now = datetime.datetime.now()
                now_time = now.strftime("%y-%m-%d %H:%M:%S")
                cur.execute("UPDATE product_view SET date=%s WHERE user_id=%s AND product_id=%s",
                            (now_time, uid, product_id))
            else:
                cur.execute("INSERT INTO product_view(user_id, product_id) VALUES(%s, %s)", (uid, product_id))
                mysql.connection.commit()
        return render_template('view_product.html', x=x, tshirts=product)
    if 'order' in request.args:
        product_id = request.args['order']
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (product_id,))
        product = curso.fetchall()
        x = content_based_filtering(product_id)
        return render_template('order_product.html', x=x, tshirts=product, form=form)
    return render_template('homecare.html', homecare=products, form=form)


@app.route('/eggmeatfish', methods=['GET', 'POST'])
def eggmeatfish():
    form = OrderForm(request.form)

    cur = mysql.connection.cursor()

    values = 'eggmeatfish'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY id ASC", (values,))
    products = cur.fetchall()

    cur.close()

    if 'view' in request.args:
        q = request.args['view']
        product_id = q
        x = content_based_filtering(product_id)
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (q,))
        products = curso.fetchall()
        return render_template('view_product.html', x=x, tshirts=products)
    elif 'order' in request.args:
        product_id = request.args['order']
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (product_id,))
        product = curso.fetchall()
        x = content_based_filtering(product_id)
        return render_template('order_product.html', x=x, tshirts=product, form=form)
    return render_template('eggmeatfish.html', eggmeatfish=products, form=form)


@app.route('/Bevearages', methods=['GET', 'POST'])
def Bevearages():
    form = OrderForm(request.form)

    cur = mysql.connection.cursor()

    values = 'Bevearages'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY id ASC", (values,))
    products = cur.fetchall()

    cur.close()

    if 'view' in request.args:
        q = request.args['view']
        product_id = q
        x = content_based_filtering(product_id)
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (q,))
        products = curso.fetchall()
        return render_template('view_product.html', x=x, tshirts=products)
    elif 'order' in request.args:
        product_id = request.args['order']
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (product_id,))
        product = curso.fetchall()
        x = content_based_filtering(product_id)
        return render_template('order_product.html', x=x, tshirts=product, form=form)
    return render_template('Bevearages.html', Bevearages=products, form=form)


@app.route('/fruitsandvegitables', methods=['GET', 'POST'])
def fruitsandvegitables():
    form = OrderForm(request.form)

    cur = mysql.connection.cursor()

    values = 'fruitsandvegitables'
    cur.execute("SELECT * FROM products WHERE category=%s ORDER BY id ASC", (values,))
    products = cur.fetchall()

    cur.close()

    if 'view' in request.args:
        q = request.args['view']
        product_id = q
        x = content_based_filtering(product_id)
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (q,))
        products = curso.fetchall()
        return render_template('view_product.html', x=x, tshirts=products)
    elif 'order' in request.args:
        product_id = request.args['order']
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM products WHERE id=%s", (product_id,))
        product = curso.fetchall()
        x = content_based_filtering(product_id)
        return render_template('order_product.html', x=x, tshirts=product, form=form)
    return render_template('fruitsandvegitables.html', fruitsandvegitables=products, form=form)


@app.route('/admin_login', methods=['GET', 'POST'])
@not_admin_logged_in
def admin_login():
    if request.method == 'POST':
        username = request.form['email']
        password_candidate = request.form['password']

        cur = mysql.connection.cursor()

        result = cur.execute("SELECT * FROM admin WHERE email=%s", [username])

        if result > 0:

            data = cur.fetchone()
            password = data['password']
            uid = data['id']
            name = data['firstName']

            # Compare password
            if (password_candidate, password):
                session['admin_logged_in'] = True
                session['admin_uid'] = uid
                session['admin_name'] = name

                return redirect(url_for('admin'))

            else:
                flash('Incorrect password', 'danger')
                return render_template('pages/login.html')

        else:
            flash('Username not found', 'danger')

            cur.close()
            return render_template('pages/login.html')
    return render_template('pages/login.html')


@app.route('/admin_out')
def admin_logout():
    if 'admin_logged_in' in session:
        session.clear()
        return redirect(url_for('admin_login'))
    return redirect(url_for('admin'))


@app.route('/admin')
@is_admin_logged_in
def admin():
    curso = mysql.connection.cursor()
    num_rows = curso.execute("SELECT * FROM products")
    result = curso.fetchall()
    order_rows = curso.execute("SELECT * FROM orders")
    users_rows = curso.execute("SELECT * FROM users")
    return render_template('pages/index.html',
                           result=result,
                           row=num_rows,
                           order_rows=order_rows,
                           users_rows=users_rows)


@app.route('/orders', methods=['GET', 'POST'])
@is_admin_logged_in
def orders():
    curso = mysql.connection.cursor()
    num_rows = curso.execute("SELECT * FROM products")
    order_rows = curso.execute("SELECT * FROM orders")
    result = curso.fetchall()
    users_rows = curso.execute("SELECT * FROM users")

    if request.method == 'POST':
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users")
        data = cur.fetchone()
        uid = data['uid']
        cur.execute("DELETE FROM orders WHERE uid=%s", uid)
        return redirect('admin')
    return render_template('pages/all_orders.html', result=result, row=num_rows, order_rows=order_rows,
                           users_rows=users_rows)


@app.route('/users')
@is_admin_logged_in
def users():
    curso = mysql.connection.cursor()
    num_rows = curso.execute("SELECT * FROM products")
    order_rows = curso.execute("SELECT * FROM orders")
    users_rows = curso.execute("SELECT * FROM users")
    result = curso.fetchall()
    return render_template('pages/all_users.html', result=result, row=num_rows, order_rows=order_rows,
                           users_rows=users_rows)


@app.route('/admin_add_product', methods=['POST', 'GET'])
@is_admin_logged_in
def admin_add_product():
    if request.method == 'POST':
        name = request.form.get('name')
        price = request.form['price']
        description = request.form['description']
        available = request.form['available']
        category = request.form['category']
        item = request.form['item']
        code = request.form['code']
        file = request.files['picture']
        if name and price and description and available and category and item and code and file:
            pic = file.filename
            photo = pic.replace("'", "")
            picture = photo.replace(" ", "_")
            if picture.lower().endswith(('.png', '.jpg', '.jpeg')):
                save_photo = photos.save(file, folder=category)
                if save_photo:

                    curs = mysql.connection.cursor()
                    curs.execute("INSERT INTO products(pName,price,description,available,category,item,pCode,picture)"
                                 "VALUES(%s, %s, %s, %s, %s, %s, %s, %s)",
                                 (name, price, description, available, category, item, code, picture))
                    mysql.connection.commit()
                    product_id = curs.lastrowid
                    curs.execute("INSERT INTO product_level(product_id)" "VALUES(%s)", [product_id])
                    if category == 'homecare':
                        level = request.form.getlist('homecare')
                        for lev in level:
                            yes = 'yes'
                            query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(field=lev)
                            curs.execute(query, (yes, product_id))

                            mysql.connection.commit()
                    elif category == 'eggmeatfish':
                        level = request.form.getlist('eggmeatfish')
                        for lev in level:
                            yes = 'yes'
                            query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(field=lev)
                            curs.execute(query, (yes, product_id))

                            mysql.connection.commit()
                    elif category == 'Bevearages':
                        level = request.form.getlist('Bevearages')
                        for lev in level:
                            yes = 'yes'
                            query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(field=lev)
                            curs.execute(query, (yes, product_id))

                            mysql.connection.commit()
                    elif category == 'fruitsandvegitables':
                        level = request.form.getlist('fruitsandvegitables')
                        for lev in level:
                            yes = 'yes'
                            query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(field=lev)
                            curs.execute(query, (yes, product_id))

                            mysql.connection.commit()
                    else:
                        flash('Product added successful', 'success')
                        return redirect(url_for('admin_add_product'))

                    curs.close()

                    flash('Product added successful', 'success')
                    return redirect(url_for('admin_add_product'))
                else:
                    flash('Picture not save', 'danger')
                    return redirect(url_for('admin_add_product'))
            else:
                flash('File not supported', 'danger')
                return redirect(url_for('admin_add_product'))
        else:
            flash('Please fill up all form', 'danger')
            return redirect(url_for('admin_add_product'))
    else:
        return render_template('pages/add_product.html')


@app.route('/confirm_order', methods=['POST', 'GET'])
@is_admin_logged_in
def confirm_order():
    if 'id' in request.args:
        status = "confirmed"
        product_id = request.args['id']
        curso = mysql.connection.cursor()
        curso.execute("UPDATE orders SET status=%s WHERE id=%s",
                         (status, product_id,))
        mysql.connection.commit()
        curso.close()
        return redirect(url_for('orders'))


@app.route('/cancel_order', methods=['POST', 'GET'])
@is_admin_logged_in
def cancel_order():
    if 'id' in request.args:
        status = "cancelled"
        product_id = request.args['id']
        curso = mysql.connection.cursor()
        curso.execute("UPDATE orders SET status=%s WHERE id=%s",
                         (status, product_id,))
        mysql.connection.commit()
        curso.close()
        return redirect(url_for('orders'))


@app.route('/delete_order', methods=['POST', 'GET'])
@is_admin_logged_in
def delete_order():
    if 'id' in request.args:
        product_id = request.args['id']
        curso = mysql.connection.cursor()
        curso.execute("DELETE FROM orders WHERE id=%s", (product_id,))
        mysql.connection.commit()
        curso.close()
        return redirect(url_for('orders'))


@app.route('/edit_product', methods=['POST', 'GET'])
@is_admin_logged_in
def edit_product():
    if 'id' in request.args:
        product_id = request.args['id']
        curso = mysql.connection.cursor()
        res = curso.execute("SELECT * FROM products WHERE id=%s", (product_id,))
        product = curso.fetchall()
        curso.execute("SELECT * FROM product_level WHERE product_id=%s", (product_id,))
        product_level = curso.fetchall()
        if res:
            if request.method == 'POST':
                name = request.form.get('name')
                price = request.form['price']
                description = request.form['description']
                available = request.form['available']
                category = request.form['category']
                item = request.form['item']
                code = request.form['code']
                file = request.files['picture']

                if name and price and description and available and category and item and code and file:
                    pic = file.filename
                    photo = pic.replace("'", "")
                    picture = photo.replace(" ", "")
                    if picture.lower().endswith(('.png', '.jpg', '.jpeg')):
                        file.filename = picture
                        save_photo = photos.save(file, folder=category)
                        if save_photo:

                            cur = mysql.connection.cursor()
                            exe = curso.execute(
                                "UPDATE products SET pName=%s, price=%s, description=%s, available=%s, category=%s, item=%s, pCode=%s, picture=%s WHERE id=%s",
                                (name, price, description, available, category, item, code, picture, product_id))
                            mysql.connection.commit()
                            if exe:
                                if category == 'homecare':
                                    level = request.form.getlist('homecare')
                                    for lev in level:
                                        yes = 'yes'
                                        query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(
                                            field=lev)
                                        cur.execute(query, (yes, product_id))

                                        mysql.connection.commit()
                                elif category == 'eggmeatfish':
                                    level = request.form.getlist('eggmeatfish')
                                    for lev in level:
                                        yes = 'yes'
                                        query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(
                                            field=lev)
                                        cur.execute(query, (yes, product_id))

                                        mysql.connection.commit()
                                elif category == 'belBevearagest':
                                    level = request.form.getlist('Bevearages')
                                    for lev in level:
                                        yes = 'yes'
                                        query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(
                                            field=lev)
                                        cur.execute(query, (yes, product_id))

                                        mysql.connection.commit()
                                elif category == 'fruitsandvegitables':
                                    level = request.form.getlist('fruitsandvegitables')
                                    for lev in level:
                                        yes = 'yes'
                                        query = 'UPDATE product_level SET {field}=%s WHERE product_id=%s'.format(
                                            field=lev)
                                        cur.execute(query, (yes, product_id))

                                        mysql.connection.commit()
                                else:
                                    flash('Product level not fund', 'danger')
                                    return redirect(url_for('admin_add_product'))
                                flash('Product updated', 'success')
                                return redirect(url_for('edit_product'))
                            else:
                                flash('Data updated', 'success')
                                return redirect(url_for('edit_product'))
                        else:
                            flash('Pic not upload', 'danger')
                            return render_template('pages/edit_product.html', product=product,
                                                   product_level=product_level)
                    else:
                        flash('File not support', 'danger')
                        return render_template('pages/edit_product.html', product=product,
                                               product_level=product_level)
                else:
                    flash('Fill all field', 'danger')
                    return render_template('pages/edit_product.html', product=product,
                                           product_level=product_level)
            else:
                return render_template('pages/edit_product.html', product=product, product_level=product_level)
        else:
            return redirect(url_for('admin_login'))
    else:
        return redirect(url_for('admin_login'))


@app.route('/search', methods=['POST', 'GET'])
def search():
    form = OrderForm(request.form)
    if 'q' in request.args:
        q = request.args['q']

        cur = mysql.connection.cursor()

        query_string = "SELECT * FROM products WHERE pName LIKE %s ORDER BY id ASC"
        cur.execute(query_string, ('%' + q + '%',))
        products = cur.fetchall()

        cur.close()
        flash('Showing result for: ' + q, 'success')
        return render_template('search.html', products=products, form=form)
    else:
        flash('Search again', 'danger')
        return render_template('search.html')


@app.route('/profile')
@is_logged_in
def profile():
    if 'user' in request.args:
        q = request.args['user']
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM users WHERE id=%s", (q,))
        result = curso.fetchone()
        if result:
            if result['id'] == session['uid']:
                curso.execute("SELECT * FROM orders WHERE uid=%s ORDER BY id ASC", (session['uid'],))
                res = curso.fetchall()
                return render_template('profile.html', result=res)
            else:
                flash('Unauthorised', 'danger')
                return redirect(url_for('login'))
        else:
            flash('Unauthorised! Please login', 'danger')
            return redirect(url_for('login'))
    else:
        flash('Unauthorised', 'danger')
        return redirect(url_for('login'))


class UpdateRegisterForm(Form):
    name = StringField('Full Name', [validators.length(min=3, max=50)],
                       render_kw={'autofocus': True, 'placeholder': 'Full Name'})
    email = EmailField('Email', [validators.DataRequired(), validators.Email(), validators.length(min=4, max=25)],
                       render_kw={'placeholder': 'Email'})
    password = PasswordField('Password', [validators.length(min=3)],
                             render_kw={'placeholder': 'Password'})
    mobile = StringField('Mobile', [validators.length(min=11, max=15)], render_kw={'placeholder': 'Mobile'})


@app.route('/settings', methods=['POST', 'GET'])
@is_logged_in
def settings():
    form = UpdateRegisterForm(request.form)
    if 'user' in request.args:
        q = request.args['user']
        curso = mysql.connection.cursor()
        curso.execute("SELECT * FROM users WHERE id=%s", (q,))
        result = curso.fetchone()
        if result:
            if result['id'] == session['uid']:
                if request.method == 'POST' and form.validate():
                    name = form.name.data
                    email = form.email.data
                    password = sha256_crypt.encrypt(str(form.password.data))
                    mobile = form.mobile.data

                    cur = mysql.connection.cursor()
                    exe = cur.execute("UPDATE users SET name=%s, email=%s, password=%s, mobile=%s WHERE id=%s",
                                      (name, email, password, mobile, q))
                    if exe:
                        flash('Profile updated', 'success')
                        return render_template('user_settings.html', result=result, form=form)
                    else:
                        flash('Profile not updated', 'danger')
                return render_template('user_settings.html', result=result, form=form)
            else:
                flash('Unauthorised', 'danger')
                return redirect(url_for('login'))
        else:
            flash('Unauthorised! Please login', 'danger')
            return redirect(url_for('login'))
    else:
        flash('Unauthorised', 'danger')
        return redirect(url_for('login'))


class DeveloperForm(Form):  #
    id = StringField('', [validators.length(min=1)],
                     render_kw={'placeholder': 'Input a product id...'})


@app.route('/developer', methods=['POST', 'GET'])
def developer():
    form = DeveloperForm(request.form)
    if request.method == 'POST' and form.validate():
        q = form.id.data
        curso = mysql.connection.cursor()
        result = curso.execute("SELECT * FROM products WHERE id=%s", (q,))
        if result > 0:
            x = content_based_filtering(q)
            wrappered = wrappers(content_based_filtering, q)
            execution_time = timeit.timeit(wrappered, number=0)
            seconds = ((execution_time / 1000) % 60)
            return render_template('developer.html', form=form, x=x, execution_time=seconds)
        else:
            nothing = 'Nothing found'
            return render_template('developer.html', form=form, nothing=nothing)
    else:
        return render_template('developer.html', form=form)


if __name__ == '__main__':
    app.run(debug=True)
