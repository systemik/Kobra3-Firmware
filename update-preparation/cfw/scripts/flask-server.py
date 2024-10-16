from flask import Flask, Response, jsonify
import subprocess

app = Flask(__name__)

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
