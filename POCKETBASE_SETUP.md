# PocketBase Setup Guide for WarframeTools

This guide explains how to set up PocketBase for the WarframeTools app authentication and data sync.

## Prerequisites

- PocketBase 0.23.2 or later
- SMTP credentials (for password reset and verification)

## 1. Running PocketBase

### Docker (Recommended)

```bash
docker run -d \
  --name pocketbase \
  -p 8090:8090 \
  -v pb_data:/pb/data \
  pocketbase/pocketbase:latest \
  serve --http=0.0.0.0:8090
```

### Local Development

```bash
./pocketbase serve
```

Access the admin UI at: `http://localhost:8090/_/`

## 2. Admin Account Setup

1. Navigate to `http://localhost:8090/_/`
2. Click "Create a new admin account"
3. Enter your admin credentials (email/password)
4. Log in with your admin account

## 3. Collection Setup

### 3.1 Create `users` Collection

The `users` collection should exist by default. Configure it as follows:

**Fields:**

| Field Name | Type | Required | Unique | Notes |
|------------|------|----------|--------|-------|
| email | Email | Yes | Yes | Primary identity |
| username | Text | No | Yes | Display name |
| verified | Bool | No | No | Default false |
| avatarUrl | URL | No | No | Profile picture link |
| relics_owned | Json | No | No | Sparse relic counters data |

**API Rules:**

| Rule Type | Rule |
|-----------|------|
| List/View | `@request.auth.id != ""` |
| Create | `@request.auth.id = ""` (public registration) |
| Update | `id = @request.auth.id` |
| Delete | `id = @request.auth.id` |

### 3.2 Create `relics_info` Collection

**Purpose:** Read-only relic metadata (synced from bundled data)

**Fields:**

| Field Name | Type | Required | Notes |
|------------|------|----------|-------|
| gid | Text | Yes | Unique identifier (e.g., "lith_a1") |
| name | Text | Yes | Display name |
| imageUrl | URL | No | Link to relic image |
| type | Select | Yes | Options: lith, meso, neo, axi, requiem |
| unvaulted | Bool | No | Default false |

**API Rules:**

| Rule Type | Rule |
|-----------|------|
| List/View | `""` (public read-only) |
| Create/Update/Delete | `@request.auth.id != ""` (admin only) |

## 4. Environment Variables

Update your `.env` file:

```env
POCKETBASE_URL=http://localhost:8090
# For production:
# POCKETBASE_URL=https://your-production-domain.com
```

## 6. Email Settings (Optional)

For email verification and password reset:

1. Go to PocketBase Settings > Mail settings
2. Configure SMTP:

   ```
   SMTP Host: smtp.gmail.com (or your provider)
   SMTP Port: 587
   SMTP Username: your-email@gmail.com
   SMTP Password: your-app-password
   ```

3. Or use a service like SendGrid, Mailgun, etc.

## 7. Testing Authentication

### Test Email/Password Auth

1. Create a test user via the app's sign-up flow
2. Try logging in with credentials

## 8. Security Recommendations

### API Rules Best Practices

```dart
// users collection - allow self-update only
Update: @request.auth.id = @request.id

// Ensure users only see/modify their own record
List/View: @request.auth.id != ""
```

### Rate Limiting

Configure in PocketBase settings to prevent abuse.

### HTTPS in Production

Always use HTTPS in production for:

- PocketBase server
- OAuth redirect URIs

## 9. Troubleshooting

access to `relics_info` and `avatars`
3. Confirm network connectivity

## 10. Production Deployment

### Security Checklist

- [ ] Enable HTTPS
- [ ] Configure proper CORS settings
- [ ] Set strong API rules
- [ ] Enable email verification (optional)
- [ ] Configure backup strategy
- [ ] Set up monitoring

### Environment-Specific Settings

```env
# Production
POCKETBASE_URL=https://api.warframetools.example.com
```

### Backup Strategy

```bash
# Backup PocketBase data
docker cp pocketbase:/pb/pb_data ./backup_pb_data

# Restore
docker cp ./backup_pb_data pocketbase:/pb/pb_data
```

## Support

- [PocketBase Documentation](https://pocketbase.io/docs/)
- [PocketBase GitHub](https://github.com/pocketbase/pocketbase)
