## Build Docker image

```docker build . -t <image_name>```

## Run container

Build ED247 library from sources on GitHub (copied when Docker container is built).
```docker run -v <local_folder>:/ed247/library/install <image_name>```

Build ED247 library from local sources 
```docker run -v <local_folder>:/ed247/library <image_name>```

### Notes:
- <local_folder> must define an absolute path (e.g. ${PWD}/ed247_library)

