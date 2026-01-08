def h [
  --help (-h)
  --find (-f): string
  ...args:any
] {
  if $help {
    help --help
  } else if $find != null {
    help --find $find ...$args
  } else {
    help ...$args
  }
  | less -R
}

def "h aliases" [
  --help (-h)
  --find (-f): string
  ...args:any
] {
  if $help {
    help --help
  } else if $find != null {
    help aliases --find $find ...$args
  } else {
    help aliases ...$args
  }
  | less -R
}

def "h commands" [
  --help (-h)
  --find (-f): string
  ...args:any
] {
  if $help {
    help --help
  } else if $find != null {
    help commands --find $find ...$args
  } else {
    help commands ...$args
  }
  | less -R
}

def "h escapes" [
  --help (-h)
] {
  if $help {
    help --help
  } else {
    help escapes
  }
  | less -R
}

def "h externs" [
  --help (-h)
  --find (-f): string
  ...args:any
] {
  if $help {
    help --help
  } else if $find != null {
    help externs --find $find ...$args
  } else {
    help externs ...$args
  }
  | less -R
}

def "h modules" [
  --help (-h)
  --find (-f): string
  ...args:any
] {
  if $help {
    help --help
  } else if $find != null {
    help modules --find $find ...$args
  } else {
    help modules ...$args
  }
  | less -R
}

def "h operators" [
  --help (-h)
] {
  if $help {
    help --help
  } else {
    help operators
  }
  | less -R
}

def "h pipe-and-redirect" [
  --help (-h)
] {
  if $help {
    help --help
  } else {
    help pipe-and-redirect
  }
  | less -R
}
