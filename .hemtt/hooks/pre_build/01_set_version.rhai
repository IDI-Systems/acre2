print("TODO Set Version in README.md, docs/_data/sidebar.yaml and extensions/src/ACRE2Shared/version.h!");
//steps_linux = [
//    "echo Setting version",
//    "sed -i -r -s 's/[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+/{{semver.major}}.{{semver.minor}}.{{semver.patch}}.{{semver.build}}/g' README.md",
//    "sed -i -r -s 's/[0-9]+\\.[0-9]+\\.[0-9]+/{{semver.major}}.{{semver.minor}}.{{semver.patch}}/g' README.md docs/_data/sidebar.yml",
//    "echo -e '#define ACRE_VERSION_MAJOR {{semver.major}}' > extensions/src/ACRE2Shared/version.h",
//    "echo -e '#define ACRE_VERSION_MINOR {{semver.minor}}' >> extensions/src/ACRE2Shared/version.h",
//    "echo -e '#define ACRE_VERSION_SUBMINOR {{semver.patch}}' >> extensions/src/ACRE2Shared/version.h",
//    "echo -e '#define ACRE_VERSION_BUILD {{semver.build}}' >> extensions/src/ACRE2Shared/version.h"
//]
//steps_windows = [
//    "echo Setting version",
//    "powershell -Command foreach ($f in 'README.md', 'docs/_data/sidebar.yml') {(Get-Content $f) -replace '[0-9]+\\.[0-9]+\\.[0-9]+', '{{semver.major}}.{{semver.minor}}.{{semver.patch}}' -join \"`n\" ^| Set-Content -NoNewline $f; Add-Content -NoNewline \"`n\" $f}",
//    "powershell -Command foreach ($f in 'README.md') {(Get-Content $f) -replace '[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+', '{{semver.major}}.{{semver.minor}}.{{semver.patch}}.{{semver.build}}' -join \"`n\" ^| Set-Content -NoNewline $f; Add-Content -NoNewline \"`n\" $f}",
//    "powershell -Command '#define ACRE_VERSION_MAJOR {{semver.major}}' > extensions/src/ACRE2Shared/version.h",
//    "powershell -Command '#define ACRE_VERSION_MINOR {{semver.minor}}' >> extensions/src/ACRE2Shared/version.h",
//    "powershell -Command '#define ACRE_VERSION_SUBMINOR {{semver.patch}}' >> extensions/src/ACRE2Shared/version.h",
//    "powershell -Command '#define ACRE_VERSION_BUILD {{semver.build}}' >> extensions/src/ACRE2Shared/version.h"
//]
