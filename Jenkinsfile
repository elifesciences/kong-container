elifePipeline {
    def commit
    stage 'Checkout', {
        checkout scm
        commit = elifeGitRevision()
    }

    node('containers-jenkins-plugin') {
        stage 'Build images', {
            checkout scm
            sh "IMAGE_TAG=${commit} ./build.sh"
        }

        elifeMainlineOnly {
            stage 'Push images', {
                image = DockerImage.elifesciences(this, "kong", commit)
                image.push().tag('latest').push()
            }
        }
    }
}
