# XConfig
XConfig is a ruby gem configuration engine  

## Usage (vendor-side)  
`extend` XConfig in you module to create `::configure` and `::xconfigure`
methods with default semantics  
`include` XConfig in any submodule you want to have `config` reader  
Remember, that configuration is stored in a
`Hash(Module, HashWithIndifferentAccess)` inside XConfig singleton  
See [Vendor Configuration](#vendor-configuration) section for more info

## Usage (client-side)  
Use either `GemName.configure do |config|` or `GemName.xconfigure do |config|`
Alternative usage:  
- use `GemName.configure('123.yml')` (or `xconfigure`)  
- use `GemName.configure(foo: { bar: 1 }, 'foo.baz' => 2)`  
Both alternatives accept block where `config` will be yielded

`config` is a proxy object for HashWithIndifferentAccess and allows call chains
like `config.gem_name.foo.bar.baz = 10`. Methods ended by bang will set value
to true
```
  config.gem_name.enabled!
  # Does same as
  config.gem_name.enabled = true
```

## Vendor Configuration  
TODO  
