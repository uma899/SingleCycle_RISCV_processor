# s.tcl - ModelSim simulation script for the RISC-V Processor

# Define the log file name
set LOG_FILE_NAME "simulation_transcript.log"



# --- Start logging the transcript output to a file ---
puts "Starting transcript logging to $LOG_FILE_NAME..."
# CORRECTED LINE: Use 'transcript file' for transcript output
transcript file $LOG_FILE_NAME

# --- Rest of your existing s.tcl script ---

# --- 1. Clean up previous simulation artifacts ---
if {[file exists work]} {
    puts "Cleaning up existing 'work' library..."
    vdel -all -lib work
}

# --- 2. Create and map the 'work' library ---
puts "Creating and mapping 'work' library..."
vlib work

# --- 3. Compile all Verilog design files and the testbench ---
puts "Compiling Verilog design files and testbench..."
vlog -sv -mfcu \
    alu_control_unit.v \
    alu.v \
    control_unit.v \
    data_memory.v \
    instruction_memory.v \
    mux2_to_1.v \
    pc_unit.v \
    processor.v \
    program_counter.v \
    register_file.v \
    sign_extender.v \
    tb_PC.v \
    tb_processor.v

puts "Compilation initiated. Check the transcript window for any errors (and now in $LOG_FILE_NAME)."

# --- 4. Start the simulation ---
puts "Starting simulation of work.processor_tb..."
vsim work.processor_tb

# --- 5. Configure the Wave window (for GUI mode) ---
puts "Adding signals to Wave window..."
add wave -position insertpoint sim:/processor_tb/*

# --- 6. Run the simulation ---
puts "Running simulation..."
run 250 ns

# --- 7. Optional: Save waveform and exit ModelSim ---
# Uncomment the lines below if you want to automatically save the waveform and exit ModelSim
# (useful for batch mode execution).
# puts "Simulation complete. Saving waveform to processor_tb.wlf..."
# write wave processor_tb.wlf
# puts "Exiting ModelSim."
# quit -force

# --- Stop logging the transcript output ---
puts "Stopping transcript logging."
# CORRECTED LINE: Use 'transcript file -off' to stop
transcript file -off

puts "Simulation script finished. Transcript saved to $LOG_FILE_NAME."