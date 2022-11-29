
macro(check_linux_package_start)
    set(LINUX_PACKAGES)
endmacro()

macro(check_linux_package package_name)
    list(APPEND LINUX_PACKAGES ${package_name})
endmacro()

macro(check_linux_package_end)

    string (REPLACE ";" "\n" packages "${LINUX_PACKAGES}")

    file(WRITE "/tmp/pkg.txt" ${packages})
    execute_process(
        COMMAND  apt list --installed ${LINUX_PACKAGES} 
        ERROR_QUIET
        OUTPUT_FILE "/tmp/apt_pkg.txt"
    )
    execute_process(
        COMMAND grep -Fwoif /tmp/pkg.txt /tmp/apt_pkg.txt
        COMMAND grep -f- -Fviw /tmp/pkg.txt
        ERROR_QUIET
        OUTPUT_FILE "/tmp/missing.txt"
    )
    file(READ /tmp/missing.txt missing_packages)

    string(REGEX REPLACE "\n$" "" failed_package_list_temp "${missing_packages}")
    string (REPLACE "\n" ";" failed_package_list "${failed_package_list_temp}")

    file(REMOVE /tmp/pkg.txt /tmp/apt_pkg.txt /tmp/missing.txt)
endmacro()

macro(check_ssh_config)

    execute_process(
        COMMAND  grep -i "^PermitUserEnvironment[ ]*yes" /etc/ssh/sshd_config
        ERROR_QUIET
        RESULT_VARIABLE retCode
    )

    if(NOT retCode STREQUAL 0)
       
        message(SEND_ERROR "Please set 'PermitUserEnvironment yes' in /etc/ssh/sshd_config and restart ssh.")
        message(NOTICE "Please follow the document:  https://tallywiki.tallysolutions.com/display/TWP/CMakePreset#CMakePreset-AdditionalInstructionforMacOS")
    endif()

endmacro()

macro(check_ssh_environment)

    if(NOT EXISTS ".ssh/environment")

        message(SEND_ERROR "File not found: .ssh/environment (at user's home directory)")
        message(NOTICE "Please follow the document:  https://tallywiki.tallysolutions.com/display/TWP/CMakePreset#CMakePreset-AdditionalInstructionforMacOS")
        if(CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
            message(NOTICE "Commands to restart ssh:")
            message(NOTICE "   sudo killall sshd")
            message(NOTICE "Note: above command will restart ssh daemon, so you need to reconnect your existing ssh sessions.")
        endif()
        if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)
            message(NOTICE "Commands to restart ssh:")
            message(NOTICE "   sudo service ssh restart")
        endif()
    endif()

    execute_process(
        COMMAND  stat -f %Sp .ssh/environment
        RESULT_VARIABLE retCode
        OUTPUT_VARIABLE out
        ERROR_VARIABLE error
    )

    if(NOT out MATCHES "-rw-------")
       
        message(SEND_ERROR "File .ssh/environment does not have permission 600.")
        message(NOTICE "Please follow the document:  https://tallywiki.tallysolutions.com/display/TWP/CMakePreset#CMakePreset-AdditionalInstructionforMacOS")

    endif()

endmacro()


macro(check_env_variable variable)

    if(NOT DEFINED ENV{${variable}})
       
        list(APPEND failed_env_variables ${variable})

    endif()

endmacro()

if(CMAKE_HOST_SYSTEM_NAME STREQUAL Windows)
    
    message(NOTICE "Verifying environment variables ...")

    set(failed_env_variables)

    check_env_variable("JAVA_HOME")

    list(LENGTH failed_env_variables failed_count)
    if(NOT failed_count STREQUAL 0)
        
         foreach(var ${failed_env_variables})
            message(NOTICE "Environment variable ${var} not defined, please set it in system environment variable and restart Visual Studio.")
         endforeach()
         
         message(SEND_ERROR "One or more environment variables not defined.")
 
     endif()

     if(NOT EXISTS $ENV{JAVA_HOME}/bin/java.exe)

        message(SEND_ERROR "Invalid JAVA_HOME set -> file not found: $ENV{JAVA_HOME}/bin/java.exe")

     endif()

endif()

if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)

   message(NOTICE "Verifying packages installed on Linux ...")

   set(failed_package_list)
   check_linux_package_start()
   check_linux_package("zip")
   check_linux_package("unzip")
   check_linux_package("build-essential")
   check_linux_package("libstdc++-10-dev")
   check_linux_package("gdbserver")
   check_linux_package("openssh-server")
   check_linux_package("libgl1-mesa-dev")
   check_linux_package("libdouble-conversion-dev")
   check_linux_package("libpcre2-16-0")
   check_linux_package("zlib1g")
   check_linux_package("zlib1g-dev")
   check_linux_package("libpcre2-dev")
   check_linux_package("libglib2.0-dev")
   check_linux_package("libgl1-mesa-dev")
   check_linux_package("libglfw3-dev")
   check_linux_package("libgles2-mesa-dev")
   check_linux_package("libegl1-mesa-dev")
   check_linux_package("libegl-dev")
   check_linux_package("libgegl-dev")
   check_linux_package("libatspi2.0-0")
   check_linux_package("libatspi2.0-dev")
   check_linux_package("libudev-dev")
   check_linux_package("libpng-dev")
   check_linux_package("libharfbuzz-dev")
   check_linux_package("libfreetype-dev")
   check_linux_package("libfontconfig1-dev")
   check_linux_package("libmtdev-dev")
   check_linux_package("libinput-dev")
   check_linux_package("libxcb-xkb-dev")
   check_linux_package("libxkbcommon-dev")
   check_linux_package("libx11-xcb-dev")
   check_linux_package("libxcb-composite0-dev")
   check_linux_package("libkf5pulseaudioqt-dev")
   check_linux_package("libfontconfig1-dev")
   check_linux_package("libfreetype6-dev")
   check_linux_package("libx11-dev")
   check_linux_package("libx11-xcb-dev")
   check_linux_package("libxext-dev")
   check_linux_package("libxfixes-dev")
   check_linux_package("libxi-dev")
   check_linux_package("libxrender-dev")
   check_linux_package("libxcb1-dev")
   check_linux_package("libxcb-glx0-dev")
   check_linux_package("libxcb-keysyms1-dev")
   check_linux_package("libxcb-image0-dev")
   check_linux_package("libxcb-shm0-dev")
   check_linux_package("libxcb-icccm4-dev")
   check_linux_package("libxcb-sync-dev")
   check_linux_package("libxcb-xfixes0-dev")
   check_linux_package("libxcb-shape0-dev")
   check_linux_package("libxcb-randr0-dev")
   check_linux_package("libxcb-render-util0-dev")
   check_linux_package("libxcb-util-dev")
   check_linux_package("libxcb-xinerama0-dev")
   check_linux_package("libxcb-xkb-dev")
   check_linux_package("libxkbcommon-dev")
   check_linux_package("libxkbcommon-x11-dev")
   check_linux_package("libxcb-xinput-dev")
   check_linux_package("libxcb-xinput0")
   check_linux_package("libtiff-dev")
   check_linux_package("libgbm-dev")
   check_linux_package("pulseaudio")
   check_linux_package("libdrm-dev")
   check_linux_package("libssl-dev")
   check_linux_package("qemu-kvm")
   check_linux_package("qemu-utils")
   check_linux_package("libgtk-3-dev")
   
   check_linux_package_end()


   list(LENGTH failed_package_list failed_count)
   if(NOT failed_count STREQUAL 0)
       
        message(NOTICE "Follow this page to install required packages on Linux : https://tallywiki.tallysolutions.com/display/TWP/Install+Required+Software+on+Linux+x64+Host")
        message(NOTICE "Run following command to install missing packages:")
        set(INSTALL_FILE $ENV{HOME}/install-missing.sh)
        file(WRITE ${INSTALL_FILE} "#!/bin/bash\n\napt update\n")
        foreach(PKG ${failed_package_list})
           message(NOTICE "   sudo apt install ${PKG} -y")
           file(APPEND ${INSTALL_FILE} "apt install ${PKG} -y\n")
        endforeach()
        file(APPEND ${INSTALL_FILE} "echo === Script execution completed. ===")
        file(CHMOD ${INSTALL_FILE} FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
        message(NOTICE "(OR) run 'sudo ${INSTALL_FILE}' to install missing packages.")
        message(SEND_ERROR "One or more packages not installed.")

    endif()
endif()

macro(check_update_git)
    message(NOTICE "Verifying git HoeBrew environment  ...")
    execute_process(
        COMMAND   git remote -v
        RESULT_VARIABLE retCode
        OUTPUT_VARIABLE out
        ERROR_VARIABLE error
        WORKING_DIRECTORY /opt/homebrew
    )
    message(NOTICE "out ${out} and retCode ${retCode} and error ${error}")
    if(out MATCHES "fatal: detected dubious ownership")
       
        message(SEND_ERROR "Ownership issue of .git directory. fixing it...")
        #execute_process(
        #    COMMAND  git config --global --add safe.directory /opt/homebrew
        #    RESULT_VARIABLE retCode
         #   OUTPUT_VARIABLE out
         #   ERROR_VARIABLE error
       # )
        if(out MATCHES "fatal: detected dubious ownership")
            message(SEND_ERROR "Ownership issue of .git directory not fixed. Please contact TWPMT team.")
        endif()

    endif()


endmacro()

if(CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
    
    message(NOTICE "Verifying ssh config ...")

    check_ssh_config()
    check_ssh_environment()
    check_update_git()

    message(NOTICE "Verifying environment variables ...")

    set(failed_env_variables)

    check_env_variable("HOME")

    list(LENGTH failed_env_variables failed_count)
    if(NOT failed_count STREQUAL 0)
    
        foreach(var ${failed_env_variables})
            message(NOTICE "Environment variable ${var} not defined, please set it in .ssh/environment file at user's home directory.")
        endforeach()
     
        message(SEND_ERROR "One or more environment variables not defined.")

    endif()

    message(NOTICE "Verifying if wrong cmake installed from VS ...")
    if(EXISTS ".vs/cmake/bin/cmake")
        message(SEND_ERROR "Found file '~/.vs/cmake/bin/cmake', please run 'rm -rf ~/.vs/cmake' to cleanup this first.")
    endif()

endif()
