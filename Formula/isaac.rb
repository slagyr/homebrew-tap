class Isaac < Formula
  desc "Compose your AI assistant from installable modules"
  homepage "https://github.com/slagyr/isaac-foundation"
  url "https://github.com/slagyr/isaac-foundation/archive/refs/tags/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "f91c5ff2751daeac5ea564d13bc60498be6818767d6ec6dff46c3bb4eae23b3e"
  license "MIT"

  depends_on "borkdude/brew/babashka"

  def install
    root = libexec/"isaac-foundation"
    root.install "libexec", "src"

    deps_home = libexec/"deps-home"
    deps_home.mkpath
    ENV["HOME"] = deps_home
    system Formula["babashka"].opt_bin/"bb", "--config", root/"libexec/bb.edn", "prepare"
    system root/"libexec/isaac", "--version"

    (bin/"isaac").write <<~EOS
      #!/usr/bin/env bash
      export CLJ_CONFIG="#{deps_home}/.clojure"
      export DEPS_CLJ_DIR="#{deps_home}/.deps.clj"
      exec "#{root}/libexec/isaac" "$@"
    EOS
  end

  test do
    assert_match "isaac", shell_output("#{bin}/isaac help")
    assert_match version.to_s, shell_output("#{bin}/isaac --version")
    system bin/"isaac", "--root", testpath/"isaac-root", "init"
    assert_path_exists testpath/"isaac-root/config/isaac.edn"
  end
end