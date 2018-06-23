import mysql.connector
from datetime import datetime, timedelta

cnx = mysql.connector.connect(user='root', password='root', host='localhost', database='messageboard')
cursor = cnx.cursor()

query = ("SELECT username, post_time, message FROM comment WHERE post_time BETWEEN %s AND %s")

date_start = datetime.today() - timedelta(days=10)
date_end = datetime.today()

cursor.execute(query, (date_start, date_end))

for (username, message, time) in cursor:
  print("Username:{} posted{} on {:%d %b %Y}".format(
    username, message, post_time))
    
cursor.close()
cnx.close()

if __name__ == "__main__":
    main()
