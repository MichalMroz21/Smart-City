file(GLOB FOLDER_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.hpp *.h)

target_sources(appSmartCity PRIVATE
    ${FOLDER_FILES}
)
