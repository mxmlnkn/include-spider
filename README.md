# include-spider

## Usage

```
incvis <source-file> [<inc-path>[:<inc-path[...]]]
```
E.g.
```
incvis src/libPMacc/include/nvidia/reduce/Reduce.hpp ./src/libPMacc/include
```
The output would be
```
src/libPMacc/include/nvidia/reduce/Reduce.hpp
    ./src/libPMacc/include/nvidia/functors/Assign.hpp
    ./src/libPMacc/include/traits/GetValueType.hpp
        ./src/libPMacc/include/traits/GetValueType.tpp
    ./src/libPMacc/include/pmacc_types.hpp
        ./src/libPMacc/include/debug/PMaccVerbose.hpp
            ./src/libPMacc/include/debug/VerboseLog.hpp
                ./src/libPMacc/include/debug/VerboseLogMakros.hpp
                    ./src/libPMacc/include/debug/VerboseLog.hpp -> already loaded
                ./src/libPMacc/include/pmacc_types.hpp -> already loaded
```
