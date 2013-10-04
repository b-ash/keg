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
                    'vendor/js/jquery.js'
                ]

        stylesheets:
            defaultExtension: 'css'
            joinTo: 'static/css/app.css'
            order:
                after: [
                    'vendor/styles/normalize.css'
                    'vendor/styles/helpers.css'
                ]

    minify: yes

    server:
        path: 'app.coffee'
        port: 5050
        base: ''
