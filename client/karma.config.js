const argv = require('yargs').argv;
const path = require('path');

module.exports = function (config) {
    config.set({
        // only use PhantomJS for our 'test' browser
        browsers: ['PhantomJS'],

        // just run once by default unless --watch flag is passed
        singleRun: !argv.watch,
                
        captureConsole: true,

        colors: true,

        // which karma frameworks do we want integrated
        frameworks: ['mocha', 'chai'],

        // displays tests in a nice readable format
        reporters: ['spec', 'coverage', 'threshold', 'junit'],

        coverageReporter: {
          dir: './coverage',
          reporters: [
            { type: 'html', subdir: 'html' },
            { type: 'cobertura', subdir: '.', file: 'cobertura.txt' },
            { type: 'text' },
            { type: 'text-summary', subdir: '.', file: 'summary.txt' }
          ]
        },

        junitReporter: {
          outputDir: './reports'
        },

        thresholdReporter: {
          statements: 90,
          branches: 90,
          functions: 90,
          lines: 90,
        },

        // include some polyfills for babel and phantomjs
        files: [
            'node_modules/babel-polyfill/dist/polyfill.js',
            './node_modules/phantomjs-polyfill/bind-polyfill.js',
            './app/**/*.spec.js' // specify files to watch for tests
        ],
        preprocessors: {
            // these files we want to be precompiled with webpack
            // also run tests throug sourcemap for easier debugging
            ['./app/**/*.spec.js']: ['webpack', 'sourcemap']
        },
        // A lot of people will reuse the same webpack config that they use
        // in development for karma but remove any production plugins like UglifyJS etc.
        // I chose to just re-write the config so readers can see what it needs to have
        webpack: {
            devtool: 'inline-source-map',
            resolve: {
                // allow us to import components in tests like:
                // import Example from 'components/Example';
                root: path.resolve(__dirname, './app'),

                // allow us to avoid including extension name
                extensions: ['', '.js', '.jsx'],

                // required for enzyme to work properly
                alias: {
                    'sinon': 'sinon/pkg/sinon'
                }
            },
            isparta: {
              embedSource: true,
              noAutoWrap: true,
            },
            module: {
                // don't run babel-loader through the sinon module
                noParse: [
                    /node_modules\/sinon\//
                ],
                preLoaders: [
                  {
                    test: /\.js$/,
                    loader: 'isparta',
                    include: path.resolve('./app'),
                    exclude: [/node_modules/, /\.spec.js$/]
                  }
                ],
                loaders: [
                  {
                    test: /\.spec.js$/,
                    loader: 'babel',
                    include: path.resolve('./app'),
                    exclude: /node_modules/,
                  }
                ],
            },
            // required for enzyme to work properly
            externals: {
                'jsdom': 'window',
                'cheerio': 'window',
                'react/addons': true,
                'react/lib/ExecutionEnvironment': true,
                'react/lib/ReactContext': 'window'
            },
        },
        webpackMiddleware: {
            noInfo: true,
            stats: {
                colors: true,
                hash: false,
                version: false,
                timings: false,
                assets: false,
                chunks: false,
                modules: false,
                reasons: false,
                children: false,
                source: false,
                errors: true,
                errorDetails: true,
                warnings: false,
                publicPath: false
            }
        },
        // tell karma all the plugins we're going to be using to prevent warnings
        plugins: [
            'karma-chai',
            'karma-coverage',
            'karma-junit-reporter',
            'karma-mocha',
            'karma-phantomjs-launcher',
            'karma-sourcemap-loader',
            'karma-spec-reporter',
            'karma-threshold-reporter',
            'karma-webpack'
        ]
    });
};
