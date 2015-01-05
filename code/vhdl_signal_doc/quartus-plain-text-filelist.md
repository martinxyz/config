== Quartus Plain Text Filelist

Hack to maintain a single .txt list of source files shared by multiple
tools. Questa can use a filelist directly. For Quartus a *.qip* file
needs to be created (maybe there is an easier way, but it works).

=== common_filelist.txt

    ../../source/core/queues/queue.vhd
    ../../source/core/path_rx_top.vhd
    etc.

=== compile.do (Questa/Modelsim script)

    ...
    eval vcom $VCOM_OPTIONS -f ../../path/to/common_filelist.txt
    ...
   
=== top.qsf (Quartus project)

    ...
    set_global_assignment -name QIP_FILE ../path/to/common_filelist.qip
    ...

=== common_filelist.qip

    set fp [open "../../../path/to/common_filelist.qip" r]
    while { [gets $fp line] >= 0 } {
        regsub -all {[ \r\t\n]+} $line "" line
        if { [string compare $line ""] != 0 } {
            set_global_assignment -name VHDL_FILE ../$line
        }
    }
    close $fp
