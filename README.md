# misty-helper

Create new virtual environment
```bash
python3 -m venv myenv
```

Activate new virtual environment
```bash
source env/bin/activate  # Linux/macOS
.\env\Scripts\activate   # Windows
```

Install necessary packages for this 
```bash
pip -r requirements.txt
```

To run backend server:
```bash
cd misty_backend
python manage.py migrate
python manage.py runserver
```
