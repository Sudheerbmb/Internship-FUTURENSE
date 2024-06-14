from flask import Flask, jsonify
import MySQLdb

app = Flask(__name__)

mysql_host = 'localhost'
mysql_user = 'root'
mysql_password = 'Sudheer@123'
mysql_db = 'practice'  

@app.route('/api/persons', methods=['GET'])
def get_persons():
    try:
        conn = MySQLdb.connect(host=mysql_host, user=mysql_user, password=mysql_password, db=mysql_db)
        cursor = conn.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM Persons')  
        persons = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(persons)
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True, port=8678)
