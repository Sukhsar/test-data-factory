# test-data-factory

The infamous test data factory that I end up using in every unit test class that I wrote.

I did a bit of research before settling down to this particular pattern even though I personally don't like the idea of having class name and object field name as string or map of string. The disadvantage of this is: it will never show you the class or field api dependancy but will throw you an error during runtime.
