module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-coffee'
    grunt.initConfig
        lint:
            files: ['*.js', '*.json', 'lib/*.js']
        jshint:                 # @see http://www.jshint.com/docs/
            options:
                curly:  false,  # Always need {} for 'if' 'for' etc.
                newcap: false,  # for CoffeeScript generated 'new ctor()'
                shadow: true,   # for CoffeeScript generated class definition
                undef:  true, eqeqeq: true, immed: true, latedef: true
                noarg:  true, sub:    true, boss:  true, eqnull:  true
                node:   true, strict: false
        coffee:
            app:
                src: ['src/*.coffee']
                dest: 'lib'
        watch:
            files: ["*.js", "*.json", "src/*.coffee", "test/*.coffee"]
            tasks: "coffee lint"
    grunt.registerTask 'default', 'coffee'
