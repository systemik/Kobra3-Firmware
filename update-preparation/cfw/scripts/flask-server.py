from flask import Flask, jsonify
import subprocess

app = Flask(__name__)

@app.route('/scripts/<script_name>')
def run_script(script_name):
    script_path = f'/useremain/cfw/nginx/html/scripts/{script_name}'
    result = subprocess.run([script_path], capture_output=True, text=True)
    try:
        # Run the script, capture stdout and stderr
        result = subprocess.run([script_path], capture_output=True, text=True)
        
        # Check if there was an error during script execution
        if result.returncode != 0:
            # If an error occurred, return stderr as the error message
            return jsonify({
                "success": False,
                "error": result.stderr.strip()  # Error message from the script
            }), 400  # HTTP status code 400 for bad request

        # If the script ran successfully, return stdout
        return jsonify({
            "success": True,
            "output": result.stdout.strip()  # Output from the script
        })
    
    except Exception as e:
        # Catch any other unexpected exceptions
        return jsonify({
            "success": False,
            "error": str(e)  # Return the exception message
        }), 500  # HTTP status code 500 for server error


    #return result.stdout

if __name__ == "__main__":
    app.run(host='127.0.0.1', port=5000,debug=True)


