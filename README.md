`git credential` wrapper gem
============================

```
require "gitcredential"

user_data = { :proto => "https", :host => "heroku.com", :path => "/",
              :user => "bovik" }

gc = Gitcredential.new :backend => :default

cred = gc.get user_data
cred # => nil

result = gc.set(user_data.merge(:password => "s3kr1+"))
result # => true

cred = gc.get user_data
cred # => "s3kr1+"

gc.set(user_data.merge(:password => "aW3s0m3"))

cred = gc.get user_data
cred # => "aW3s0m3"

result = gc.unset user_data
result # => true

cred = gc.get user_data
cred # => nil

result = gc.unset user_data
result # => false
```
