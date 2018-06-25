#LAMP project
#06/23/2018
#Alex Hapgood, JP Gazewood

import mysql.connector
from datetime import datetime, timedelta
import sys

def db_read():
    cnx = mysql.connector.connect(user='root', password='root', host='localhost', database='messageboard')
    cursor = cnx.cursor()

    query = ("SELECT username, message, post_date, post_time FROM comment WHERE post_date BETWEEN %s AND %s")

    date_start = datetime.today() - timedelta(days=10)
    date_end = datetime.today()

    cursor.execute(query, (date_start, date_end))

    for (username, message, post_date, post_time) in cursor:
      print("\nusr: {} posted <<{}>> on {} at {}".format(username, message, post_date, post_time))

    cursor.close()
    cnx.close()

def db_write():
    cnx = mysql.connector.connect(user='root', password='root', host='localhost', database='messageboard')
    cursor = cnx.cursor()

    time_now = datetime.now().time()
    date_now = datetime.now().date()

    mb_user = input('usr: ')
    if mb_user == "":
        mb_user = 'anon'

    mb_comment = input('message: ')
    if mb_comment == "":
        sys.exit()

    submit_comment = ("INSERT INTO comment (username, message, post_date, post_time) VALUES (%s, %s, %s, %s)")

    cursor.execute(submit_comment, (mb_user, mb_comment, date_now, time_now))

    cnx.commit()

    cursor.close()
    cnx.close()

def main():
    db_read()
    db_write()

if __name__ == "__main__":
    main()
