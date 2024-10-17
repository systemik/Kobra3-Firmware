from flask import Flask, Response, jsonify, render_template, request, redirect, url_for, flash
import subprocess
import os

app = Flask(__name__)

# Configuration
UPLOAD_FOLDER = '/useremain/cfw/nginx/html/upload/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = 'supersecretkey'  # Required for flash messages
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50 megabytes

# Ensure the upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


# Route to display the upload form
@app.route('/uploadpage/')
def index():
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Upload</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #333;
        }

        .container {
            text-align: center;
            background-color: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            font-size: 2.5em;
            margin-bottom: 20px;
            color: #4CAF50;
        }

        form {
            margin-top: 20px;
        }

        input[type="file"] {
            padding: 10px;
            font-size: 1.1em;
            margin-bottom: 20px;
        }

        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1.1em;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        @media (max-width: 600px) {
            .container {
                width: 90%;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Upload a File</h1>
        <form action="/uploadpage/upload" method="POST" enctype="multipart/form-data">
            <input type="file" name="file" required><br>
            <input type="submit" value="Upload">
        </form>
    </div>

</body>
</html>
    '''

# Route to handle the file upload
@app.route('/uploadpage/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return '''
        <h2>No file part</h2>
        <a href="/">Go back</a>
        '''

    file = request.files['file']

    if file.filename == '':
        return '''
        <h2>No file selected</h2>
        <a href="/">Go back</a>
        '''

    if file:
        # Save the file
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(file_path)
        return f'''
        <h2>File {file.filename} uploaded successfully!</h2>
        <a href="/">Go back</a>
        '''
    
# Route to execute scripts
@app.route('/scripts/<script_name>')
def run_script(script_name):
    script_path = f'/useremain/cfw/scripts/{script_name}'

    def generate_output(script_path):
        try:
            process = subprocess.Popen(
                [script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
            )

            # Read stdout line by line as it is produced
            for stdout_line in iter(process.stdout.readline, ''):
                yield f"data:{stdout_line}\n\n"  # SSE format
            
            # Wait for the process to finish and capture stderr if any
            process.stdout.close()
            process.wait()

            # If the script finishes with an error
            if process.returncode != 0:
                error_output = process.stderr.read().strip()
                yield f"data:ERROR: {error_output}\n\n"
            
        except Exception as e:
            yield f"data:ERROR: {str(e)}\n\n"

    return Response(generate_output(script_path), mimetype='text/event-stream')

if __name__ == "__main__":
    app.run(host='127.0.0.1', port=5000, debug=True)
