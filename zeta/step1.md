## Welcome to Powershell

### Getting Started

Some examples to try:

Do some math

`1 + 1`{{execute}}


Show a string

`"Hello World"`{{execute}}


Run a native PowerShell command

`Get-Process`{{execute}}


Match against a regular expression

`"Hello World" -match "H.*World"`{{execute}}


More fancy stuff

`$animal = "Cat"
if($animal -match "Goat")
{
    "Kid"
} elseif($animal -match "Cat")
{
    "Kitten"
} else
{
    "Alien"
}
`{{execute}}

## When you're done

When you're finished exploring the sandbox, click "Continue" to end this session.