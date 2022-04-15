#
# Macros
#
macro(copy_file target_name var_dest_dir var_dest var_src comment)
  set(lv "${ARGN}")
  foreach(l IN LISTS lv)
    list(APPEND dep_list ${l})
  endforeach()
  add_custom_command( OUTPUT ${var_dest}
    COMMAND ${CMAKE_COMMAND} -E make_directory    ${var_dest_dir}
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${var_src} ${var_dest}
    COMMENT ${comment}
    VERBATIM)
  add_custom_target(${target_name} ALL DEPENDS ${var_dest} ${dep_list})
endmacro()

macro(copy_files target_name var_dest_dir var_srcs comment)
  set(lv "${ARGN}")
  foreach(l IN LISTS lv)
    list(APPEND dep_list ${l})
  endforeach()
  foreach(s IN LISTS ${var_srcs})
    get_filename_component(f ${s} NAME)
    set(d ${var_dest_dir}/${f})
    list(APPEND dest_list ${d})
  endforeach()
  add_custom_command( OUTPUT ${var_dest_dir}
    COMMAND_EXPAND_LISTS
    COMMAND ${CMAKE_COMMAND} -E make_directory    ${var_dest_dir}
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${${var_srcs}} ${var_dest_dir}
    COMMENT ${comment}
    VERBATIM)
  add_custom_target(${target_name} ALL DEPENDS ${var_dest_dir} ${dep_list})
endmacro()

macro(make_app app_name)
  set(__mode "${app_name}_SRC")
  foreach(arg ${ARGN})
    if ("[${arg}]" STREQUAL "[LIBS]")
      set(__mode "${app_name}_LIBS")
    else()
        list(APPEND ${__mode} ${arg})
    endif()
  endforeach()
  add_executable(${app_name} ${${app_name}_SRC})
endmacro()

macro(make_lib lib_name type_name)
  set(lv    "${ARGN}")
  set(llist "")
  foreach(l IN LISTS lv)
    list(APPEND llist ${${l}})
  endforeach()
  if (${type_name} STREQUAL "STATIC")
    add_library(${lib_name} STATIC ${llist})
  else()
    add_library(${lib_name} DYNAMIC ${llist})
  endif()

  if(CMAKE_HOST_UNIX)
    copy_file( ${lib_name}_build ${sdk_lib}
      ${sdk_lib}/lib${lib_name}.so ${build_root}/${PROJECT_NAME}/lib${lib_name}.so
      "Copy ${lib_name} library." ${lib_name})
  endif()
endmacro()

macro(add_src var_name)
  set(lv "${ARGN}")
  foreach(l IN LISTS lv)
    file(GLOB globfiles ${l})
    list(APPEND ${var_name} ${globfiles})
  endforeach()
endmacro()

macro(if_add_src cond_name var_name)
  if (${cond_name})
    set(lv "${ARGN}")
    foreach(l IN LISTS lv)
      file(GLOB globfiles ${l})
      list(APPEND ${var_name} ${globfiles})
    endforeach()
  endif()
endmacro()

macro(sub_src var_name)
  set(lv "${ARGN}")
  foreach(l IN LISTS lv)
    file(GLOB globfiles ${l})
    list(REMOVE_ITEM ${var_name} ${globfiles})
  endforeach()
endmacro()

macro(get_platform var_name)
  # message("CMAKE_GENERATOR=${CMAKE_GENERATOR}")
  # message("CMAKE_VS_PLATFORM_NAME=${CMAKE_VS_PLATFORM_NAME}")
  # message("CMAKE_VS_PLATFORM_TOOLSET=${CMAKE_VS_PLATFORM_TOOLSET}")
  # set(${var_name} "${CMAKE_SYSTEM_NAME}${CMAKE_GENERATOR_TOOLSET}${CMAKE_GENERATOR_PLATFORM}")
  set(${var_name} "${CMAKE_SYSTEM_NAME}${CMAKE_INTERNAL_PLATFORM_ABI}")
  if(${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
    set(${var_name} "${CMAKE_VS_PLATFORM_TOOLSET}${CMAKE_VS_PLATFORM_NAME}")
  endif()
  # message("${var_name}=${${var_name}}")
endmacro()
