# flutter_nested_navigators

A flutter project to show how pop in nested navigators ~~doesn't work~~ works.

## Using

Build & run. See diagram below for explanation of pages.

       ------------
       |           |
      home      -----------------
                |       |       |
              page1   page2   page3

      home: just a button to go to page 1
      page1: states that it is page one (to differentiate) and button to get to page 2
      page2: state it is page 2, button to get to page 3. Note that if you press back it goes to home

      Expected routing:

      home -->
              page1
           <--
      home --> -->
              page 2
         page1  <--
           --> -->
              page 3
              * (won't leave)

This used to show how it doesn't work, but now that it is implemented properly as per how flutter
expects, it shows how nested navigators _DO_ work =)
