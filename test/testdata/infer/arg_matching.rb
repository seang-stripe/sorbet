# typed: true
class TestArgs
  extend T::Sig

  def any; end

  sig {returns(T::Hash[Integer, Integer])}
  def a_hash; end # error: Expected `T::Hash[Integer, Integer]` but found `NilClass` for method result type

  def required(a, b)
  end

  def call_required
    required(1)
    #        ^ error: Not enough arguments
    required(1, 2)
    required(1, 2, 3)
    #              ^ error: Expected: `2`, got: `3`
  end

  def optional(a, b=1)
  end

  def call_optional
    optional(1)
    optional(1, 2)
    optional(1, 2, 3)
    #              ^ error: Expected: `1..2`, got: `3`
  end

  sig do
    params(
      a: Integer,
      b: Integer,
    )
    .returns(NilClass)
  end
  def kwarg(a, b:)
  end

  def call_kwarg
    # "too many arguments" and "missing keyword argument b"
    kwarg(1, 2)
    #        ^ error: Too many positional arguments provided for method `TestArgs#kwarg`. Expected: `1`, got: `2`
    #     ^^^^ error: Missing required keyword argument `b` for method `TestArgs#kwarg`
    kwarg(1)
    #     ^ error: Missing required keyword argument `b`

    kwarg(1, b: 2)
    kwarg(1, b: 2, c: 3)
  # ^^^^^^^^^^^^^^^^^^^^ error: Unrecognized keyword argument `c`
    kwarg(1, {})
    #     ^^^^^ error: Missing required keyword argument `b`
    kwarg(1, b: "hi")
    #           ^^^^ error: Expected `Integer` but found `String("hi")` for argument `b`
    kwarg(1, any)
    kwarg(1, a_hash)
  # ^^^^^^^^^^^^^^^^ error: Passing a hash where the specific keys are unknown
  end

  sig do
    params(
      x: Integer
    )
    .returns(NilClass)
  end
  def repeated(*x)
  end

  def call_repeated
    repeated
    repeated(1, 2, 3)
    repeated(1, "hi")
    #           ^^^^ error: Expected `Integer` but found `String("hi")` for argument `x`

    # We error on each incorrect argument
    repeated("hi", "there")
    #        ^^^^ error: Expected `Integer` but found `String("hi")` for argument `x`
    #              ^^^^^^^ error: Expected `Integer` but found `String("there")` for argument `x`
  end

  sig do
    params(
      x: Integer,
      y: Integer,
      z: T::Hash[Integer, Integer],
      w: String,
      u: Integer,
      v: Integer
    )
    .returns(NilClass)
  end
  def mixed(x, y=T.unsafe(nil), z=T.unsafe(nil), *w, u:, v: 0)
  end

  def call_mixed
    mixed(0, u: 1)
    mixed(0, 1, u: 1)
    mixed(0, 1, {z: 1}, u: 1)
    mixed(0, 1, {z: 1}, "hi", "there", u: 1, v: 0)
  end

  def optkw(x, y=T.unsafe(nil), u:)
  end

  def call_optkw
    # There's ambiguity here about whether to report `u` or `x` as
    # missing; We follow Ruby in complaining about `u`.
    optkw(u: 1)
    #     ^^^^ error: Missing required keyword argument `u`
    optkw(1, 2, 3)
    #     ^^^^^^^    error: Missing required keyword argument `u` for method `TestArgs#optkw`
    #           ^ error: Too many positional arguments provided for method `TestArgs#optkw`. Expected: `1..2`, got: `3`
  end
end
