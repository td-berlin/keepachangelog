'use strict';

module.exports = function(grunt) {

  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  // Project configuration.
  grunt.initConfig({
    // Task configuration.
    bump: {
      options: {
        files: ['package.json'],
        updateConfigs: [],
        commit: true,
        commitMessage: 'Release %VERSION%',
        commitFiles: ['package.json'],
        createTag: true,
        tagName: '%VERSION%',
        tagMessage: 'Version %VERSION%',
        push: true,
        pushTo: 'upstream',
        gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d',
        globalReplace: false,
        prereleaseName: 'rc',
        metadata: '',
        regExp: false
      }
    },
    watch: {
      options: {
        //spawn: false
      },
      yaml: {
        files: ['**/*.yaml', '**/*.yml', '!**/node_modules/**', '!**/transformers/**'],
        tasks: ['newer:yaml_validator']
      },
      ruby: {
        files: ['**/*.rb', '!**/node_modules/**'],
        tasks: ['shell:style']
      }
    },

    // Make sure there are no obvious mistakes
    yaml_validator: {
      options: {
        structure: [],
        yaml: null
      },
      all: {
        options: {},
        src: ['**/*.yaml', '**/*.yml', '!**/node_modules/**', '!**/transformers/**', '.*.yml']
      }
    },

    shell: {
      options: {
        execOptions: {
          maxBuffer: 1024 * 1024 * 5 // 5 MiB
        }
      },
      rubocop: {
        command: 'bundle exec rubocop -D'
      },
      rspec: {
        command: 'bundle exec rspec --format=documentation'
      },
      cucumber: {
        command: 'bundle exec cucumber --fail-fast'
      },
      build: {
        command: 'gem build keepachangelog.gemspec'
      }
    },
    environments: {
      options: {
        username: process.env.SSH_USER,
        privateKey: process.env.SSH_KEY
      },
      download: {
        options: {
          host: process.env.TARGET_HOST,
          local_path: 'keepachangelog-*.gem',
          deploy_path: process.env.TARGET_PATH
        }
      }
    },

    'git-describe': {
      options: {
        // Task-specific options go here.
      },
      main: {
        // Target-specific file lists and/or options go here.
      },
    }
  });

  // Tasks
  grunt.registerTask('saveRevision', function() {
    grunt.event.once('git-describe', function(rev) {
        grunt.config.set('environments.options.tag', rev.tag);
      });
    grunt.task.run('git-describe');
  });

  grunt.registerTask('serve', ['watch']);
  grunt.registerTask('lint', ['test:style']);
  grunt.registerTask('test:style', ['yaml_validator', 'shell:rubocop']);
  grunt.registerTask('test:spec', ['shell:rspec']);
  grunt.registerTask('test:integration', ['shell:cucumber']);
  grunt.registerTask('test', ['test:style',
                              'test:spec',
                              'test:integration']);
  grunt.registerTask('build', ['shell:build']);

  grunt.registerTask('publish', function() {
    grunt.task.run('saveRevision');
    grunt.task.run(['ssh_deploy:download']);
  });

  grunt.registerTask('tag', function(target) {
    if (arguments.length === 0) {
      grunt.task.run(['test', 'bump:minor']);
    } else {
      grunt.task.run(['test', 'bump:' + target]);
    }
  });

  // Default task.
  grunt.registerTask('default', ['serve']);
};
