using BinDeps

@BinDeps.setup

libmpfit = library_dependency("libmpfit", aliases=["mpfit"])

# build from source
provides(Sources, URI("https://www.physics.wisc.edu/~craigm/idl/down/cmpfit-1.3a.tar.gz"), 
         libmpfit)

builddir = joinpath(BinDeps.depsdir(libmpfit), "src", "cmpfit-1.3a", "build")
libdir = BinDeps.libdir(libmpfit)

provides(SimpleBuild, 
         (@build_steps begin
          FileRule(joinpath(libdir,"libmpfit.so"),
                   @build_steps begin
                   GetSources(libmpfit)
                   CreateDirectory(builddir)
                   CreateDirectory(libdir)
                   @build_steps begin
                   ChangeDirectory(builddir)
                   `pwd`
                   `cp ../../../cmake.mpfit ../CMakeLists.txt`
                   `cmake ../`
                   `make`
                   `cp libmpfit.so $libdir`
                   end
                   end
                   )
          end), libmpfit)

BinDeps.@install Dict(:libmpfit => :libmpfit)
