include_directories ("${PROJECT_SOURCE_DIR}")
acre_set_linker_options()
add_executable( acre_map_test map_test.cpp)
add_executable( acre_controller_test controller_test.cpp)

target_link_libraries(acre_map_test acre_common acre_signal_static)
add_dependencies(acre_map_test acre_common acre_signal_static)
SET_TARGET_PROPERTIES(acre_map_test PROPERTIES PREFIX "")
set_target_properties(acre_map_test PROPERTIES FOLDER Tests)

target_link_libraries(acre_controller_test acre_common acre_controller_static acre_data_static acre_signal_static ${LINK_LIBS})
add_dependencies(acre_controller_test acre_common acre_controller_static acre_data_static acre_signal_static)
SET_TARGET_PROPERTIES(acre_controller_test PROPERTIES PREFIX "")
set_target_properties(acre_controller_test PROPERTIES FOLDER Tests)

# add_executable( ace_pbo_search pbo_search.cpp)
# add_dependencies(ace_pbo_search ace_common)
# target_link_libraries(ace_pbo_search ace_common)
# SET_TARGET_PROPERTIES(ace_pbo_search PROPERTIES PREFIX "")
# set_target_properties(ace_pbo_search PROPERTIES FOLDER Tests)

# add_executable( ace_vd_ext_test vd_ext_test.cpp)
# if(USE_DIRECTX)
    # add_dependencies(ace_vd_ext_test ace_common ace_vd_static)
    # target_link_libraries(ace_vd_ext_test ace_common directxtk 
    # ace_vd_static
    # ${DirectX_D3DX11_LIBRARY} ${DirectX_D3D11_LIBRARY} ${DirectX_D3D11_1_LIBRARY} ${DirectX_D3D11_2_LIBRARY} BulletDynamics BulletCollision LinearMath)
# else()
    # add_dependencies(ace_vd_ext_test ace_common ace_vd_static)
    # target_link_libraries(ace_vd_ext_test ace_common BulletDynamics BulletCollision LinearMath ace_vd_static)
# endif()
# set_target_properties(ace_vd_ext_test PROPERTIES PREFIX "")
# set_target_properties(ace_vd_ext_test PROPERTIES FOLDER Tests)

#
#
#
#

# add_executable( ace_longrod_dxtk_test longrod_dxtk_test.cpp)
# if(USE_DIRECTX)
    # add_dependencies(ace_longrod_dxtk_test ace_common ace_vd_static)
    # target_link_libraries(ace_longrod_dxtk_test ace_common directxtk 
    # ace_vd_static
    # ${DirectX_D3DX11_LIBRARY} ${DirectX_D3D11_LIBRARY} ${DirectX_D3D11_1_LIBRARY} ${DirectX_D3D11_2_LIBRARY} BulletDynamics BulletCollision LinearMath)
# else()
    # add_dependencies(ace_longrod_dxtk_test ace_common ace_vd_static)
    # target_link_libraries(ace_longrod_dxtk_test ace_common BulletDynamics BulletCollision LinearMath ace_vd_static
    # )
# endif()
# set_target_properties(ace_longrod_dxtk_test PROPERTIES PREFIX "")
# set_target_properties(ace_longrod_dxtk_test PROPERTIES FOLDER Tests)

#
#
#

# if(USE_DIRECTX)
    # add_executable( ace_test_render test_render.cpp test_render.hpp)
    # target_link_libraries(ace_test_render ace_common 
    # ${DirectX_D3DX11_LIBRARY} ${DirectX_D3D11_LIBRARY} ${DirectX_D3D11_1_LIBRARY} ${DirectX_D3D11_2_LIBRARY} BulletDynamics BulletCollision LinearMath    )
    # add_dependencies(ace_test_render ace_common)
    # SET_TARGET_PROPERTIES(ace_test_render PROPERTIES PREFIX "")
    # set_target_properties(ace_test_render PROPERTIES FOLDER Tests)
    
    # add_executable( ace_dxtk_test dxtk_test.cpp)
    # target_link_libraries(ace_dxtk_test ace_common directxtk 
    # ${DirectX_D3DX11_LIBRARY} ${DirectX_D3D11_LIBRARY} ${DirectX_D3D11_1_LIBRARY} ${DirectX_D3D11_2_LIBRARY} BulletDynamics BulletCollision LinearMath)
    # add_dependencies(ace_dxtk_test ace_common directxtk)
  
    # SET_TARGET_PROPERTIES(ace_dxtk_test PROPERTIES PREFIX "")
    # set_target_properties(ace_dxtk_test PROPERTIES FOLDER Tests)
# endif()
