class Isaac < Formula
  desc "Compose your AI assistant from installable modules"
  homepage "https://github.com/slagyr/isaac-foundation"
  url "https://github.com/slagyr/isaac-foundation/archive/refs/tags/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "a6c1dee062c02c4dde928aa11b54ccbe2ab54e15a5d8d1aa499d3cfd5075aac2"
  license "MIT"
  head "https://github.com/slagyr/isaac-foundation.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "borkdude/brew/babashka"

  def install
    root = libexec/"isaac-foundation"
    root.install "libexec", "src"

    deps_home = libexec/"deps-home"
    deps_home.mkpath
    smoke_root = buildpath/"isaac-smoke-root"
    smoke_root.mkpath
    ENV["HOME"] = deps_home
    system Formula["babashka"].opt_bin/"bb", "--config", root/"libexec/bb.edn", "prepare"
    system root/"libexec/isaac", "--root", smoke_root, "help"
    system root/"libexec/isaac", "--root", smoke_root, "--version"

    (bin/"isaac").write <<~EOS
      #!/usr/bin/env bash
      export CLJ_CONFIG="${CLJ_CONFIG:-#{deps_home}/.clojure}"
      export DEPS_CLJ_DIR="${DEPS_CLJ_DIR:-#{deps_home}/.deps.clj}"
      exec "#{root}/libexec/isaac" "$@"
    EOS
  end

  test do
    deps_home = testpath/"deps-home"
    deps_home.mkpath
    cp_r "#{libexec}/deps-home/.", deps_home

    ENV["CLJ_CONFIG"] = "#{deps_home}/.clojure"
    ENV["DEPS_CLJ_DIR"] = "#{deps_home}/.deps.clj"

    smoke_root = testpath/"isaac-smoke-root"
    smoke_root.mkpath

    assert_match "isaac", shell_output("#{bin}/isaac --root #{smoke_root} help")
    assert_match version.to_s, shell_output("#{bin}/isaac --root #{smoke_root} --version")
    system bin/"isaac", "--root", testpath/"isaac-root", "init"
    assert_path_exists testpath/"isaac-root/config/isaac.edn"
  end
end