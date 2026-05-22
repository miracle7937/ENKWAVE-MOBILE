import com.android.build.gradle.LibraryExtension
import org.gradle.api.tasks.compile.JavaCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // AGP 8+ requires namespace and compileSdk 30+ on all Android library modules.
    afterEvaluate {
        extensions.findByType<LibraryExtension>()?.apply {
            if ((compileSdk ?: 0) < 34) {
                compileSdk = 34
            }
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
            buildFeatures {
                buildConfig = true
            }
            if (namespace.isNullOrBlank()) {
                val manifest = project.file("src/main/AndroidManifest.xml")
                if (manifest.exists()) {
                    val packageName = Regex("""package="([^"]+)"""")
                        .find(manifest.readText())
                        ?.groupValues
                        ?.get(1)
                    if (!packageName.isNullOrBlank()) {
                        namespace = packageName
                    }
                }
            }
        }
    }

    tasks.withType<KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }

    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_17.toString()
        targetCompatibility = JavaVersion.VERSION_17.toString()
    }
}

// Plugin build.gradle files may set Java 1.8 / low compileSdk after the block above; re-apply after each project evaluates.
gradle.afterProject {
    extensions.findByType<LibraryExtension>()?.apply {
        if ((compileSdk ?: 0) < 34) {
            compileSdk = 34
        }
        compileOptions.apply {
            sourceCompatibility = JavaVersion.VERSION_17
            targetCompatibility = JavaVersion.VERSION_17
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
