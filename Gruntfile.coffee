module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files: [
          expand: true,
          cwd: 'src',
          src: ['{,*/}*.coffee'],
          dest: 'lib',
          ext: '.js'
        ]

    jasmine_node:
      options:
        forceExit: true
        match: '.'
        matchall: false
        specNameMatcher: 'spec'
        coffee: true
      all: ['test']

  grunt.loadNpmTasks 'grunt-jasmine-node'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-release'
      
  grunt.registerTask 'test', [ 'jasmine_node' ]
  grunt.registerTask 'build', [ 'test', 'coffee' ]
  grunt.registerTask 'publish', [ 'build', 'release']
  grunt.registerTask 'default', [ 'build' ]
