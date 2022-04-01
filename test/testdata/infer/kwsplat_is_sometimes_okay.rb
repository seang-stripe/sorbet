# typed: strict
extend T::Sig

sig {params(x: T.nilable(String), y: T.nilable(String)).void}
def takes_all_required_nilable(x:, y:); end
sig {params(x: T.nilable(String), y: T.nilable(String)).void}
def takes_some_required_nilable(x:, y: nil); end
sig {params(x: T.nilable(String), y: T.nilable(String)).void}
def takes_all_optional_nilable(x: nil, y: nil); end

sig {params(x: String, y: String).void}
def takes_all_required(x:, y:); end
sig {params(x: String, y: String).void}
def takes_some_required(x:, y: ''); end
sig {params(x: String, y: String).void}
def takes_all_optional(x: '', y: ''); end

sig {params(x: String, y: String).void}
def takes_all_required_untyped(x:, y:); end
sig {params(x: String, y: String).void}
def takes_some_required_untyped(x:, y: ''); end
sig {params(x: String, y: String).void}
def takes_all_optional_untyped(x: '', y: ''); end

def takes_all_required_unsigged(x:, y:); end # error: does not have a `sig`
def takes_some_required_unsigged(x:, y: ''); end # error: does not have a `sig`
def takes_all_optional_unsigged(x: '', y: ''); end # error: does not have a `sig`

sig {params(x: Integer, y: String).void}
def takes_one_int_one_str(x: 0, y: ''); end

sig do
  params(
    opts: T::Hash[Symbol, String],
    nilable_opts: T::Hash[Symbol, T.nilable(String)],
    mixed_opts: T::Hash[Symbol, T.any(Integer, String)],
    untyped_opts: T::Hash[Symbol, T.untyped],
  )
  .void
end
def example(opts, nilable_opts, mixed_opts, untyped_opts)
  takes_all_required_nilable(**opts)
  #                          ^^^^^^ error: Cannot call `Object#takes_all_required_nilable` with a `Hash` keyword splat because the method has required keyword parameters
  takes_some_required_nilable(**opts)
  #                           ^^^^^^ error: Cannot call `Object#takes_some_required_nilable` with a `Hash` keyword splat because the method has required keyword parameters

  # It might be nice to get better locations for these two in the future, and
  # also to somehow allow them.
  takes_some_required_nilable(x: nil, **opts)
  #                           ^^^^^^^^^^^^^^ error: Cannot call `Object#takes_some_required_nilable` with a `Hash` keyword splat because the method has required keyword parameters
  takes_some_required_nilable(**opts, x: nil)
  #                           ^^^^^^^^^^^^^^ error: Cannot call `Object#takes_some_required_nilable` with a `Hash` keyword splat because the method has required keyword parameters

  takes_all_optional_nilable(**opts)

  takes_all_required(**opts)
  #                  ^^^^^^ error: Cannot call `Object#takes_all_required` with a `Hash` keyword splat because the method has required keyword parameters
  takes_some_required(**opts)
  #                   ^^^^^^ error: Cannot call `Object#takes_some_required` with a `Hash` keyword splat because the method has required keyword parameters
  takes_all_optional(**opts)
  takes_all_optional(**nilable_opts)
  #                  ^^^^^^^^^^^^^^ error: Expected `String` for keyword parameter `x` but found `T.nilable(String)` from keyword splat
  takes_all_optional(**mixed_opts)
  #                  ^^^^^^^^^^^^ error: Expected `String` for keyword parameter `x` but found `T.any(Integer, String)` from keyword splat
  takes_all_optional(**untyped_opts)


  takes_all_required_untyped(**opts)
  #                          ^^^^^^ error: Cannot call `Object#takes_all_required_untyped` with a `Hash` keyword splat because the method has required keyword parameters
  takes_some_required_untyped(**opts)
  #                           ^^^^^^ error: Cannot call `Object#takes_some_required_untyped` with a `Hash` keyword splat because the method has required keyword parameters
  takes_all_optional_untyped(**opts)

  takes_all_required_unsigged(**opts)
  #                           ^^^^^^ error: Cannot call `Object#takes_all_required_unsigged` with a `Hash` keyword splat because the method has required keyword parameters
  takes_some_required_unsigged(**opts)
  #                            ^^^^^^ error: Cannot call `Object#takes_some_required_unsigged` with a `Hash` keyword splat because the method has required keyword parameters
  takes_all_optional_unsigged(**opts)

  takes_one_int_one_str(**opts)
  #                     ^^^^^^ error: Expected `Integer` for keyword parameter `x` but found `String` from keyword splat
  takes_one_int_one_str(**nilable_opts)
  #                     ^^^^^^^^^^^^^^ error: Expected `Integer` for keyword parameter `x` but found `T.nilable(String)` from keyword splat
  takes_one_int_one_str(**mixed_opts)
  #                     ^^^^^^^^^^^^ error: Expected `Integer` for keyword parameter `x` but found `T.any(Integer, String)` from keyword splat
  takes_one_int_one_str(**untyped_opts)
end
