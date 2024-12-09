def create_binary_diff(file1, file2, diff_file):
    with open(file1, "rb") as f1, open(file2, "rb") as f2:
        data1 = f1.read()
        data2 = f2.read()

    # Ensure the files are of the same size
    max_len = max(len(data1), len(data2))
    data1 = data1.ljust(max_len, b'\x00')  # Pad with null bytes if needed
    data2 = data2.ljust(max_len, b'\x00')

    # Collect differences
    diff = []
    for i in range(max_len):
        if data1[i] != data2[i]:
            diff.append((i, data2[i]))  # Record the offset and new byte value

    # Save the diff to a file
    with open(diff_file, "w") as df:
        for offset, byte in diff:
            df.write(f"{offset} {byte}\n")

# Example usage
create_binary_diff("/userdata/app/gk/K3SysUiBak", "/userdata/app/gk/K3SysUi", "K3SysUi.diff")

