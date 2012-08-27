context("A developer can bundle all R package dependencies.")

#' Ensures that a pcakage and it's dependencies are installed when running 'bundle'
#' @param desc a description of the test
#' @param pkg the test package
#' @param expected_dependencies a vector of dependencies which must be installed
test_bundle <- function(desc, pkg, expected_dependencies) {
  test_that(
            desc,
            {

              options(repos=structure(c(CRAN="http://cran.us.r-project.org")))

              package <- as.package(pkg)
              lib <- bundle_library(package$path)

              bundle(package$path)

              expect_true(file.exists(lib), sprintf("Bundler library [%s] was not created.", lib))

              bundle_package_path <- file.path(lib, package$package)
              expect_true(
                          file.exists(bundle_package_path),
                          sprintf("Package was not successfully installed into bundler library: [%s]", bundle_package_path)
                          )
              # Dependencies successfully installed:
              for(dependency in expected_dependencies) {
                bundle_dependency_path <- file.path(lib, dependency)
                expect_true(
                            file.exists(bundle_dependency_path),
                            sprintf("Dependency was not successfully installed into bundler library: [%s]", bundle_dependency_path)
                            )
              }

              unlink(lib, recursive=TRUE)

            }
            )
}

test_bundle(
            desc = "Bundling a package with no dependencies creates a bundle directory with the project installed and no dependencies installed.",
            pkg = 'no-dependencies',
            expected_dependencies = c()
            )

test_bundle(
            desc = "Bundling a package with dependencies creates a bundle directory with the project installed and all dependencies installed.",
            pkg = "simple-dependencies",
            expected_dependencies=c('PerformanceAnalytics')
            )
