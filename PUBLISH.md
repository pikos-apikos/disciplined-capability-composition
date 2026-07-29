# Publishing the Repository

The repository is already initialized on the `main` branch with an initial commit.

## Recommended repository metadata

- **Owner:** `pikos-apikos`
- **Name:** `disciplined-capability-composition`
- **Visibility:** Public
- **Description:** `An RFC for building reliable and secure systems around non-deterministic language models through typed capability composition.`
- **Suggested topics:** `llm`, `ai-agents`, `workflow-engine`, `distributed-systems`, `ai-safety`, `observability`, `prompt-injection`, `model-drift`, `rfc`

## Publish with GitHub CLI

From the repository directory:

```bash
./publish.sh
```

The script verifies GitHub authentication, creates the public repository when it does not exist, sets the remote, and pushes `main`.

## Publish manually

Create an empty public GitHub repository named `disciplined-capability-composition`, then run:

```bash
git remote add origin git@github.com:pikos-apikos/disciplined-capability-composition.git
git push -u origin main
```
