///usr/bin/true; exec /usr/bin/env go run "$0" "$0"
package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// runCmd executes a local command, captures its stdout as a string,
// prints the exact command being run, and returns the output or an error.
func runCmd(name string, args ...string) (string, error) {
	// Print what we are executing (mimicking your echo statements)
	fmt.Printf("Running: %s %s\n", name, strings.Join(args, " "))

	cmd := exec.Command(name, args...)
	
	// .Output() runs the command and captures its standard output
	stdoutBytes, err := cmd.CombinedOutput() // Captures BOTH stdout and stderr
	outputStr := string(stdoutBytes)

	if err != nil {
		return outputStr, fmt.Errorf("command failed: %w", err)
	}
	return outputStr, nil
}

func main() {
	// 1. Argument and Validation Layer
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Usage: go run main.go <SIF_FILE> [LINK_FILE]")
		os.Exit(1)
	}

	sifFile := os.Args[1]
	var linkFile string
	if len(os.Args) > 2 {
		linkFile = os.Args[2]
	}

	// Check if SIF file exists locally
	if _, err := os.Stat(sifFile); err == nil {
		fmt.Printf("Sif file: %s\n", sifFile)
	} else {
		fmt.Fprintf(os.Stderr, "Missing file %s\n", sifFile)
		os.Exit(1)
	}

	// Validate link file text
	if linkFile != "" {
		fmt.Printf("Link:     %s\n", linkFile)
	} else {
		fmt.Println("Missing name of link")
	}

	// 2. Basename Extraction (mimicking `basename`)
	sifName := filepath.Base(sifFile)
	fmt.Printf("SIF_NAME: %s\n", sifName)

	// Strip specific extension from the base name
	linkBase := filepath.Base(linkFile)
	if strings.HasSuffix(linkBase, ".sif") {
		linkBase = strings.TrimSuffix(linkBase, ".sif")
	}
	fmt.Printf("LINK_BASE: %s\n", linkBase)

	// 3. Execution Pipeline

	// Step A: Remove old link via SSH
	// Note: Running multiple operations over SSH is safest when joined into one shell command string
	sshRemoveCmd := fmt.Sprintf("cd /mnt/Pool1/container && rm -vf %s", linkFile)
	out, err := runCmd("ssh", "lapras", sshRemoveCmd)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error removing old link: %v\n%s\n", err, out)
	} else {
		fmt.Print(out)
	}

	// Step B: Send file to remote host via rsync
	fmt.Println("Sending file to lapras")
	out, err = runCmd("rsync", "-avP", sifFile, "lapras:/mnt/Pool1/container")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Rsync failed: %v\n%s\n", err, out)
		os.Exit(1)
	}
	fmt.Print(out)

	// Step C: Create new symlink via SSH
	fmt.Println("Creating new link")
	sshLinkCmd := fmt.Sprintf("cd /mnt/Pool1/container && ln -s %s %s", sifName, linkFile)
	out, err = runCmd("ssh", "lapras", sshLinkCmd)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating link: %v\n%s\n", err, out)
		os.Exit(1)
	}
	fmt.Print(out)

	// Step D: List Sif files matching base name via SSH
	fmt.Println("Sif files")
	sshListCmd := fmt.Sprintf("cd /mnt/Pool1/container && ls -l %s*.*", linkBase)
	out, err = runCmd("ssh", "lapras", sshListCmd)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error listing files: %v\n%s\n", err, out)
	} else {
		fmt.Print(out)
	}

	// Step E: Local md5sum calculation
	out, err = runCmd("md5sum", sifFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error calculating md5sum: %v\n%s\n", err, out)
	} else {
		fmt.Print(out)
	}

	// Step F: Final confirmation of link target via SSH
	sshConfirmCmd := fmt.Sprintf("cd /mnt/Pool1/container && ls -l %s", linkFile)
	out, err = runCmd("ssh", "lapras", sshConfirmCmd)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error confirming link: %v\n%s\n", err, out)
	} else {
		fmt.Print(out)
	}
}

