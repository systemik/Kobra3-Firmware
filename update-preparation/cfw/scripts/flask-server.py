from flask import Flask, Response, jsonify, render_template, request, redirect, url_for, flash
import subprocess
import os

app = Flask(__name__)

# Configuration
UPLOAD_FOLDER = 'uploads/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = 'supersecretkey'  # Required for flash messages
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50 megabytes

# Ensure the upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


# Route to display the upload form
@app.route('/uploadpage')
def index():
    return render_template('upload.html')

# Route to handle the file upload
@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        flash('No file part')
        return redirect(request.url)

    file = request.files['file']

    if file.filename == '':
        flash('No selected file')
        return redirect(request.url)

    if file:
        # Save the file
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(file_path)
        flash(f'File {file.filename} uploaded successfully!')
        return redirect(url_for('index'))
    
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
    app.run(host='127.0.0.1', port=5000)
