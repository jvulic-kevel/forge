# Default action is to show available commands.
default:
    @just --list

# Apply the system configuration.
apply command="switch" host="apple":
    echo "Applying system configuration..."; \
    sudo darwin-rebuild switch --flake .#{{host}}; \

# Build configuration.
build host="apple":
    echo "Building system configuration (dry-run/check)..."; \
    darwin-rebuild build --flake .#{{host}}; \

# Update all flake inputs or a specific input.
update input="":
    @if [ -z "{{input}}" ]; then \
        echo "Updating all flake inputs..."; \
        nix flake update; \
    else \
        echo "Updating flake input {{input}}..."; \
        nix flake update {{input}}; \
    fi

# Verify configuration. It builds but does not switch -- equivalent to dry-run
# verification.
test host="apple":
    @echo "Evaluating and dry-run building host configuration: {{host}}..."
    nix eval --experimental-features "nix-command flakes" .#darwinConfigurations.{{host}}.system --show-trace >/dev/null
    nix build --dry-run --experimental-features "nix-command flakes" .#darwinConfigurations.{{host}}.system
    @echo "Success! Host configuration '{{host}}' is healthy."

# Run garbage collection and optimize the nix store.
clean:
    @echo "Pruning older profile generations..."
    nix-collect-garbage -d
    @echo "Running Nix store garbage collection..."
    nix-store --gc
