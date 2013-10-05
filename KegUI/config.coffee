module.exports.config =
  paths:
    public: 'public'

  files:
    javascripts:
      defaultExtension: 'coffee'
      joinTo:
        'static/js/app.js': /^app/
        'static/js/vendor.js': /^vendor/
      order:
        before: [
          'vendor/scripts/jquery.js'
          'vendor/scripts/jquery.scrollto.js'
          'vendor/scripts/jquery.ticker.js'
          'vendor/scripts/bootstrap.js'
          'vendor/scripts/moment.js'
          'vendor/scripts/handlebars.js'
          'vendor/scripts/underscore.js'
          'vendor/scripts/backbone.js'
          'vendor/scripts/vex.combined.js'
          'vendor/scripts/vex.mixen.coffee'
          'vendor/scripts/mixen.coffee'
        ]

    stylesheets:
      defaultExtension: 'css'
      joinTo: 'static/css/app.css'
      order:
        before: [
          'vendor/styles/vex.css'
          'vendor/styles/vex-theme-wireframe.css'
        ]
        after: [
          'vendor/styles/normalize.css'
          'vendor/styles/helpers.css'
        ]

    templates:
      defaultExtension: 'hbs'
      joinTo: 'static/js/app.js'

  minify: yes

  server:
    path: 'app.coffee'
    port: 5050
    base: ''
