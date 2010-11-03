desc "Clean, update, test, package project"
task :build do
  sh './sbt/sbt.sh', 'clean', 'update', 'test', 'package'
end

namespace :build do
  desc "Remove build artifacts"
  task :clean do
    sh './sbt/sbt.sh', 'clean', 'reload'
  end

  desc "Update dependencies"
  task :update do
    sh './sbt/sbt.sh', 'update'
  end

  desc "Compile source"
  task :compile do
    if ENV.include?('CI')
      sh './sbt/sbt.sh', '~compile'
    else
      sh './sbt/sbt.sh', 'compile'
    end
  end

  desc "Check specifications"
  task :test do
    if ENV.include?('CI')
      sh './sbt/sbt.sh', '~test'
    else
      sh './sbt/sbt.sh', 'test'
    end
  end

  desc "Create runnable package"
  task :package do
    sh './sbt/sbt.sh', 'package'
  end

  desc "Start an interactive Scala console"
  task :console do
    sh './sbt/sbt.sh', 'console-quick'
  end

  desc 'Start codefellow daemon for Vim intellisense'
  task :codefellow do
    sh './sbt/sbt.sh', 'codefellow'

    dir = '/home/kputnam/wd/codefellow'
    sh 'java', '-cp', "#{dir}/project/boot/scala-2.8.0.RC5/lib/scala-library.jar:" +
                      "#{dir}/project/boot/scala-2.8.0.RC5/lib/scala-compiler.jar:" +
                      "#{dir}/codefellow-core/target/scala_2.8.0.RC5/classes",
                      'de.tuxed.codefellow.Launch'
  end
end
