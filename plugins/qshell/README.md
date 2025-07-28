# Qiniu qshell oh-my-zsh Plugin

A comprehensive oh-my-zsh plugin for Qiniu qshell CLI, providing aliases, functions, and auto-completion for Qiniu Cloud Storage operations.

## Features

- **Auto-completion**: Uses official `qshell completion zsh` for accurate command completion
- **Aliases**: Short aliases for common qshell operations
- **Helper functions**: Advanced functions for account, bucket, and file management
- **Batch operations**: Simplified batch upload, download, and file operations
- **Safety features**: Confirmation prompts for destructive operations
- **Smart loading**: Only loads if qshell is installed

## Installation

1. Place this plugin in your oh-my-zsh custom plugins directory:
```bash
# If using the zsh-custom structure
plugins=(... qshell)
```

2. Reload your shell:
```bash
source ~/.zshrc
```

## Prerequisites

- [Qiniu qshell](https://developer.qiniu.com/kodo/tools/1302/qshell) must be installed
- A valid Qiniu Cloud Storage account with Access Key and Secret Key

## Basic Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `qs` | `qshell` | Main qshell command |
| `qsv` | `qshell version` | Show version |
| `qsh` | `qshell help` | Show help |

## Account Management Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `qsa` | `qshell account` | Account management |
| `qsal` | `qshell account list` | List all accounts |
| `qsadd` | `qshell account add` | Add new account |
| `qsarm` | `qshell account remove` | Remove account |
| `qsas` | `qshell account switch` | Switch account |
| `qsai` | `qshell account info` | Show current account |

## Bucket Management Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `qsb` | `qshell bucket` | Bucket management |
| `qsbl` | `qshell bucket list` | List all buckets |
| `qsbi` | `qshell bucket info` | Show bucket info |
| `qsbc` | `qshell bucket create` | Create bucket |
| `qsbd` | `qshell bucket delete` | Delete bucket |

## File Operations Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `qsl` / `qsls` | `qshell listbucket` | List bucket contents |
| `qsu` / `qsup` | `qshell rput` | Upload single file |
| `qsd` / `qsdl` | `qshell get` | Download single file |
| `qsrm` / `qsdel` | `qshell delete` | Delete file |
| `qscp` | `qshell copy` | Copy file |
| `qsmv` | `qshell move` | Move file |
| `qsren` | `qshell rename` | Rename file |

## Batch Operations Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `qsbu` | `qshell qupload` | Batch upload |
| `qsbd` | `qshell qdownload` | Batch download |
| `qsbdel` | `qshell batchdelete` | Batch delete |
| `qsbcp` | `qshell batchcopy` | Batch copy |
| `qsbmv` | `qshell batchmove` | Batch move |
| `qsbren` | `qshell batchrename` | Batch rename |

## Sync and CDN Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `qsync` | `qshell qupload2` | Synchronize upload |
| `qsdown` | `qshell qdownload2` | Synchronize download |
| `qscdn` | `qshell cdnrefresh` | CDN refresh |
| `qspfop` | `qshell pfop` | Persistent operations |
| `qspfops` | `qshell pfopstatus` | Check pfop status |

## Utility Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `qsstat` | `qshell stat` | Show file statistics |
| `qsdu` / `qsinfo` | `qshell bucketinfo` | Show bucket info |

## Helper Functions

### Account Management
```bash
# List all accounts
qsaccount

# Add new account
qsaccount add <name> <access_key> <secret_key>

# Switch to account
qsaccount switch <name>

# Remove account
qsaccount remove <name>

# Show current account info
qsaccount info
```

### Bucket Operations
```bash
# List all buckets
qsbucket

# Show bucket information
qsbucket info <bucket_name>

# Create new bucket
qsbucket create <bucket_name> <region>
# Regions: z0(华东), z1(华北), z2(华南), na0(北美), as0(东南亚)

# Delete bucket (with confirmation)
qsbucket delete <bucket_name>
```

### File Upload & Download
```bash
# Quick file upload
qsupload <local_file> <bucket:key> [overwrite]
qsupload ./photo.jpg mybucket:images/photo.jpg
qsupload ./photo.jpg mybucket:images/photo.jpg true

# Quick file download
qsdownload <bucket> <key> [local_file]
qsdownload mybucket images/photo.jpg ./downloaded_photo.jpg
```

### List Bucket Contents
```bash
# List bucket contents with pagination
qslist <bucket> [prefix] [limit]
qslist mybucket
qslist mybucket images/ 50
```

### Batch Operations
```bash
# Batch upload with config file
qsbatchup <config_file>

# Generate upload config template
qsconfig [bucket] [src_dir] [config_file]
qsconfig mybucket ./uploads upload.conf
```

### File Operations with Safety
```bash
# Delete file with confirmation
qsdelete <bucket> <key>

# Copy file with confirmation
qscopy <src_bucket> <src_key> <dest_bucket> <dest_key>

# File statistics
qsfilestat <bucket> <key>
```

### CDN Operations
```bash
# Refresh multiple URLs
qsrefresh <url1> [url2] [url3] ...
qsrefresh https://example.com/file1.jpg https://example.com/file2.jpg
```

### Directory Sync
```bash
# Quick sync directory to bucket
qssync <local_dir> <bucket> [key_prefix]
qssync ./images mybucket images/
```

### Status Overview
```bash
# Show comprehensive qshell status
qsstatus
```

## Auto-completion

The plugin uses the official `qshell completion zsh` command to provide accurate and up-to-date auto-completion for:
- All qshell commands and subcommands
- Command flags and options
- Bucket names and file keys
- The completion is automatically generated and cached for better performance

## Examples

### Basic Setup
```bash
# Add your Qiniu account
qsaccount add myaccount AK123456789 SK987654321

# Switch to the account
qsaccount switch myaccount

# List your buckets
qsbl
```

### File Operations
```bash
# Upload a single file
qsupload ./document.pdf mybucket:docs/document.pdf

# Download a file
qsdownload mybucket docs/document.pdf ./local_document.pdf

# List files in bucket
qslist mybucket docs/

# Get file statistics
qsfilestat mybucket docs/document.pdf
```

### Batch Operations
```bash
# Create upload configuration
qsconfig mybucket ./uploads

# Edit the generated config file as needed
# Then batch upload
qsbatchup upload.conf

# Sync entire directory
qssync ./website mybucket web/
```

### CDN Management
```bash
# Refresh CDN cache for files
qsrefresh https://cdn.example.com/image1.jpg https://cdn.example.com/image2.jpg
```

### Bucket Management
```bash
# Create a new bucket in East China region
qsbucket create newbucket z0

# Get bucket information
qsbucket info newbucket

# Delete bucket (will prompt for confirmation)
qsbucket delete oldbucket
```

## Configuration Files

### Upload Configuration Template
When using `qsconfig`, a configuration file is generated with these options:
```json
{
    "src_dir": "./",
    "bucket": "mybucket",
    "key_prefix": "",
    "overwrite": false,
    "check_exists": true,
    "check_hash": true,
    "check_size": true,
    "ignore_dir": false,
    "up_host": "",
    "bind_up_ip": "",
    "bind_nic": "",
    "resettable_api": true,
    "thread_count": 5
}
```

## Safety Features

The plugin includes safety features for destructive operations:
- **Confirmation prompts** for delete operations
- **File existence checks** before operations
- **Overwrite protection** by default

## Qiniu Regions

When creating buckets, use these region codes:
- `z0` - 华东 (East China)
- `z1` - 华北 (North China)  
- `z2` - 华南 (South China)
- `na0` - 北美 (North America)
- `as0` - 东南亚 (Southeast Asia)

## Common Workflows

### Initial Setup
```bash
# 1. Add account
qsaccount add main YOUR_ACCESS_KEY YOUR_SECRET_KEY

# 2. Verify account
qsaccount info

# 3. List available buckets
qsbl
```

### File Management
```bash
# Upload files
qsupload ./file.txt mybucket:path/file.txt

# List and verify
qslist mybucket path/

# Download when needed
qsdownload mybucket path/file.txt ./downloaded_file.txt
```

### Website Deployment
```bash
# Sync website files
qssync ./dist mybucket web/

# Refresh CDN
qsrefresh https://mysite.com/index.html https://mysite.com/app.js
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This plugin is released under the MIT License.