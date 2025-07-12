import os
  import sqlite3
  import subprocess
  import pickle

  # SQL Injection vulnerability
  def get_user(user_id):
      conn = sqlite3.connect('users.db')
      cursor = conn.cursor()
      # Vulnerable: Direct string concatenation
      query = f"SELECT * FROM users WHERE id = {user_id}"
      cursor.execute(query)
      return cursor.fetchone()

  # Command Injection vulnerability
  def backup_file(filename):
      # Vulnerable: User input directly in shell command
      command = f"cp {filename} /backup/"
      os.system(command)

  # Deserialization vulnerability
  def load_user_data(data):
      # Vulnerable: Unpickling untrusted data
      return pickle.loads(data)

  # Hardcoded credentials
  DATABASE_PASSWORD = "admin123"
  API_KEY = "sk-1234567890abcdef"

  # Path traversal vulnerability
  def read_file(filename):
      # Vulnerable: No path validation
      with open(f"/app/files/{filename}", 'r') as f:
          return f.read()

  if __name__ == "__main__":
      # Simulate vulnerable usage
      user = get_user("1 OR 1=1")
      backup_file("../../../etc/passwd")