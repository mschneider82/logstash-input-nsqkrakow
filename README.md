logstash-input-nsqkrakow THIS IS JUST A POC - PLEASE READ:
====================

This is a NSQ input Plugin for Logstash. It will consume messages from a nsq topic using [krakow](https://github.com/chrisroberts/krakow). 
Unfortunately this plugin is really slow compared to my other [logstash-input-nsq](https://github.com/mschneider82/logstash-input-nsq) plugin using nsq-ruby. Its mostly the same plugin code.
[Krakow](https://github.com/chrisroberts/krakow) has more features like TLS (not yet implemented into this plugin because processing speed sucks), maybe someone can enhance this plugin to better processing speed. PR and forks are welcome.

At the moment I recommend using [logstash-input-nsq](https://github.com/mschneider82/logstash-input-nsq)

For more information about NSQ, refer to this [documentation](http://nsq.io) 

celluloid is enforced to be version 0.16.0 because krakow has an [issue with 0.17.0](https://github.com/chrisroberts/krakow/issues/35)

Install
====================

     /opt/logstash/bin/plugin install logstash-input-nsqkrakow

Logstash Configuration
====================

    input {
       nsqkrakow {
            nsqlookupd => "http://localhost:4161"
            topic => "testtopic"
            channel => "testchannel"
            max_in_flight  => 200
       }
    }

Dependencies
====================

* krakow

# Logstash Plugin

This is a plugin for [Logstash](https://github.com/elasticsearch/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.


## Documentation

Logstash provides infrastructure to automatically generate documentation for this plugin. We use the asciidoc format to write documentation so any comments in the source code will be first converted into asciidoc and then into html. All plugin documentation are placed under one [central location](http://www.elasticsearch.org/guide/en/logstash/current/).

- For formatting code or config example, you can use the asciidoc `[source,ruby]` directive
- For more asciidoc formatting tips, see the excellent reference here https://github.com/elasticsearch/docs#asciidoc-guide

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Running your unpublished Plugin in Logstash

#### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-filter-awesome", :path => "/your/local/logstash-filter-awesome"
```
- Install plugin
```sh
bin/plugin install --no-verify
```
- Run Logstash with your plugin
```sh
bin/logstash -e 'filter {awesome {}}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

#### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-filter-awesome.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/plugin install /your/local/plugin/logstash-filter-awesome.gem
```
- Start Logstash and proceed to test the plugin

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elasticsearch/logstash/blob/master/CONTRIBUTING.md) file.
