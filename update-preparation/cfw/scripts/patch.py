def apply_binary_diff(original_file, diff_file, output_file):
    # Read the original binary file
    with open(original_file, "rb") as f:
        data = bytearray(f.read())

    # Read the patch
    with open(diff_file, "r") as df:
        for line in df:
            offset, byte = line.split()
            data[int(offset)] = int(byte)  # Update the byte at the given offset

    # Write the patched data to a new file
    with open(output_file, "wb") as out:
        out.write(data)

# Go for it
apply_binary_diff("/userdata/app/gk/K3SysUi", "/useremain/cfw/scripts/K3SysUi.diff", "/userdata/app/gk/K3SysUi")

