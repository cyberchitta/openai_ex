---
name: sty-elixir
description: Provides Elixir-specific style guidelines emphasizing functional programming patterns, OTP principles, pattern matching, and "The Elixir Way". Use for Elixir projects to ensure idiomatic, maintainable, and concurrent code.
---

## Elixir-Specific Guidelines

### Functional Programming Patterns

- Prefer pattern matching over conditional logic (`case`, `with`, function heads)
- Use pipe operators (`|>`) for clear data transformations and function composition
- Leverage recursion and `Enum` functions instead of imperative loops
- Keep functions pure and composable - avoid side effects in business logic
- Use guards to express function preconditions clearly

### Data Flow and Transformation

- Design data pipelines with the pipe operator for readability
- Use `Enum.map/2`, `Enum.filter/2`, `Enum.reduce/3` over manual recursion when appropriate
- Prefer list comprehensions for complex transformations: `for x <- list, condition, do: transform(x)`
- Use `Stream` for lazy evaluation of large or infinite data sets

### Error Handling

- Use `with/else` for clean error handling in complex operations
- Prefer `{:ok, result}` / `{:error, reason}` tuples for explicit error returns
- Let processes crash and restart - embrace "let it crash" philosophy
- Use `try/rescue` sparingly, only for external library integration

### OTP and Concurrency

- Structure stateful operations around OTP principles (GenServer, Supervisor, etc.)
- Design with immutability and message-passing concurrency in mind
- Use `Task` for fire-and-forget operations and `Task.async/await` for coordinated concurrency
- Prefer lightweight processes over threads - spawn liberally

### Code Organization

- Use protocols for polymorphic behavior instead of inheritance
- Organize modules by domain/context, not by technical layer
- Keep modules focused - prefer many small modules over large ones
- Use `use` and `import` judiciously - prefer explicit module calls for clarity

### Naming and Style

- Use snake_case for functions, variables, and atoms
- Use PascalCase for modules and protocols
- Use descriptive names that express intent: `calculate_tax/1` not `calc/1`
- Prefer explicit return values over implicit ones
