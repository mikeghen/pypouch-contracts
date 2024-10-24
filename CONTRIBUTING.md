# Contributing to PyPouch

We're thrilled that you're interested in contributing to PyPouch! This document provides guidelines for contributing to the project. Please take a moment to review this document to make the contribution process easy and effective for everyone involved.

## Code of Conduct

By participating in this project, you are expected to uphold our [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started

- Make sure you have a [GitHub account](https://github.com/signup/free)
- Fork the repository on GitHub
- Clone your fork locally
- Set up the development environment as described in the README.md

## Making Changes

1. Create a topic branch from where you want to base your work.
   * This is usually the `main` branch.
   * To quickly create a topic branch based on main, run `git checkout -b fix/my_contribution main`. 
     Please avoid working directly on the `main` branch.

2. Make commits of logical and atomic units.

3. Check for unnecessary whitespace with `git diff --check` before committing.

4. Make sure your commit messages are in the proper format:
   ```
   Short (50 chars or less) summary of changes

   More detailed explanatory text, if necessary. Wrap it to about 72
   characters or so. In some contexts, the first line is treated as the
   subject of an email and the rest of the text as the body. The blank
   line separating the summary from the body is critical (unless you omit
   the body entirely); tools like rebase can get confused if you run the
   two together.

   Further paragraphs come after blank lines.

   - Bullet points are okay, too
   - Typically a hyphen or asterisk is used for the bullet, preceded by a
     single space, with blank lines in between, but conventions vary here
   ```

5. Make sure you have added the necessary tests for your changes.

6. Run all the tests to assure nothing else was accidentally broken.

## Submitting Changes

1. Push your changes to a topic branch in your fork of the repository.

2. Submit a pull request to the main PyPouch repository.

3. The core team looks at Pull Requests on a regular basis and will provide feedback.

4. After feedback has been given we expect responses within two weeks. After two weeks we may close the pull request if it isn't showing any activity.

## Reporting Bugs

1. Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/yourusername/pypouch/issues).

2. If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/yourusername/pypouch/issues/new). Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## Suggesting Enhancements

1. Open a new issue with a clear title and detailed description of the suggested enhancement.

2. Explain why this enhancement would be useful to most PyPouch users.

3. Provide examples of how the feature would be used if applicable.

## Additional Resources

* [General GitHub documentation](https://help.github.com/)
* [GitHub pull request documentation](https://help.github.com/articles/creating-a-pull-request/)

Thank you for your contributions to PyPouch!