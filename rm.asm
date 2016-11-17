
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 a7 08 00 00       	push   $0x8a7
  21:	6a 02                	push   $0x2
  23:	e8 9a 04 00 00       	call   4c2 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 b7 02 00 00       	call   2e7 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 02 00 00       	call   337 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 bb 08 00 00       	push   $0x8bb
  74:	6a 02                	push   $0x2
  76:	e8 47 04 00 00       	call   4c2 <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
    }
  }

  exit();
  8b:	e8 57 02 00 00       	call   2e7 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	90                   	nop
  b2:	5b                   	pop    %ebx
  b3:	5f                   	pop    %edi
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c2:	90                   	nop
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8d 50 01             	lea    0x1(%eax),%edx
  c9:	89 55 08             	mov    %edx,0x8(%ebp)
  cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d5:	0f b6 12             	movzbl (%edx),%edx
  d8:	88 10                	mov    %dl,(%eax)
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 e2                	jne    c3 <strcpy+0xd>
    ;
  return os;
  e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e4:	c9                   	leave  
  e5:	c3                   	ret    

000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e9:	eb 08                	jmp    f3 <strcmp+0xd>
    p++, q++;
  eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	74 10                	je     10d <strcmp+0x27>
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	38 c2                	cmp    %al,%dl
 10b:	74 de                	je     eb <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 d0             	movzbl %al,%edx
 116:	8b 45 0c             	mov    0xc(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	0f b6 c0             	movzbl %al,%eax
 11f:	29 c2                	sub    %eax,%edx
 121:	89 d0                	mov    %edx,%eax
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <strlen>:

uint
strlen(char *s)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 132:	eb 04                	jmp    138 <strlen+0x13>
 134:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 138:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	01 d0                	add    %edx,%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 ed                	jne    134 <strlen+0xf>
    ;
  return n;
 147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14a:	c9                   	leave  
 14b:	c3                   	ret    

0000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14f:	8b 45 10             	mov    0x10(%ebp),%eax
 152:	50                   	push   %eax
 153:	ff 75 0c             	pushl  0xc(%ebp)
 156:	ff 75 08             	pushl  0x8(%ebp)
 159:	e8 32 ff ff ff       	call   90 <stosb>
 15e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x51>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 47 01 00 00       	call   2ff <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x5e>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x5f>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f3:	7c b3                	jl     1a8 <gets+0xf>
 1f5:	eb 01                	jmp    1f8 <gets+0x5f>
      break;
 1f7:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	6a 00                	push   $0x0
 213:	ff 75 08             	pushl  0x8(%ebp)
 216:	e8 0c 01 00 00       	call   327 <open>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x26>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 25                	jmp    253 <stat+0x4b>
  r = fstat(fd, st);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	ff 75 0c             	pushl  0xc(%ebp)
 234:	ff 75 f4             	pushl  -0xc(%ebp)
 237:	e8 03 01 00 00       	call   33f <fstat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	ff 75 f4             	pushl  -0xc(%ebp)
 248:	e8 c2 00 00 00       	call   30f <close>
 24d:	83 c4 10             	add    $0x10,%esp
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 262:	eb 25                	jmp    289 <atoi+0x34>
    n = n*10 + *s++ - '0';
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	89 d0                	mov    %edx,%eax
 269:	c1 e0 02             	shl    $0x2,%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	01 c0                	add    %eax,%eax
 270:	89 c1                	mov    %eax,%ecx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8d 50 01             	lea    0x1(%eax),%edx
 278:	89 55 08             	mov    %edx,0x8(%ebp)
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	0f be c0             	movsbl %al,%eax
 281:	01 c8                	add    %ecx,%eax
 283:	83 e8 30             	sub    $0x30,%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x48>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c7                	jle    264 <atoi+0xf>
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b4:	eb 17                	jmp    2cd <memmove+0x2b>
    *dst++ = *src++;
 2b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b9:	8d 50 01             	lea    0x1(%eax),%edx
 2bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c8:	0f b6 12             	movzbl (%edx),%edx
 2cb:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2cd:	8b 45 10             	mov    0x10(%ebp),%eax
 2d0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d3:	89 55 10             	mov    %edx,0x10(%ebp)
 2d6:	85 c0                	test   %eax,%eax
 2d8:	7f dc                	jg     2b6 <memmove+0x14>
  return vdst;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2df:	b8 01 00 00 00       	mov    $0x1,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <exit>:
SYSCALL(exit)
 2e7:	b8 02 00 00 00       	mov    $0x2,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <wait>:
SYSCALL(wait)
 2ef:	b8 03 00 00 00       	mov    $0x3,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <pipe>:
SYSCALL(pipe)
 2f7:	b8 04 00 00 00       	mov    $0x4,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <read>:
SYSCALL(read)
 2ff:	b8 05 00 00 00       	mov    $0x5,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <write>:
SYSCALL(write)
 307:	b8 10 00 00 00       	mov    $0x10,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <close>:
SYSCALL(close)
 30f:	b8 15 00 00 00       	mov    $0x15,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <kill>:
SYSCALL(kill)
 317:	b8 06 00 00 00       	mov    $0x6,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <exec>:
SYSCALL(exec)
 31f:	b8 07 00 00 00       	mov    $0x7,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <open>:
SYSCALL(open)
 327:	b8 0f 00 00 00       	mov    $0xf,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mknod>:
SYSCALL(mknod)
 32f:	b8 11 00 00 00       	mov    $0x11,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <unlink>:
SYSCALL(unlink)
 337:	b8 12 00 00 00       	mov    $0x12,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <fstat>:
SYSCALL(fstat)
 33f:	b8 08 00 00 00       	mov    $0x8,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <link>:
SYSCALL(link)
 347:	b8 13 00 00 00       	mov    $0x13,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <mkdir>:
SYSCALL(mkdir)
 34f:	b8 14 00 00 00       	mov    $0x14,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <chdir>:
SYSCALL(chdir)
 357:	b8 09 00 00 00       	mov    $0x9,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <dup>:
SYSCALL(dup)
 35f:	b8 0a 00 00 00       	mov    $0xa,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <getpid>:
SYSCALL(getpid)
 367:	b8 0b 00 00 00       	mov    $0xb,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <sbrk>:
SYSCALL(sbrk)
 36f:	b8 0c 00 00 00       	mov    $0xc,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <sleep>:
SYSCALL(sleep)
 377:	b8 0d 00 00 00       	mov    $0xd,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <uptime>:
SYSCALL(uptime)
 37f:	b8 0e 00 00 00       	mov    $0xe,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <gettime>:
SYSCALL(gettime)
 387:	b8 16 00 00 00       	mov    $0x16,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <settickets>:
SYSCALL(settickets)
 38f:	b8 17 00 00 00       	mov    $0x17,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 18             	sub    $0x18,%esp
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a3:	83 ec 04             	sub    $0x4,%esp
 3a6:	6a 01                	push   $0x1
 3a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ab:	50                   	push   %eax
 3ac:	ff 75 08             	pushl  0x8(%ebp)
 3af:	e8 53 ff ff ff       	call   307 <write>
 3b4:	83 c4 10             	add    $0x10,%esp
}
 3b7:	90                   	nop
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	53                   	push   %ebx
 3be:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cc:	74 17                	je     3e5 <printint+0x2b>
 3ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d2:	79 11                	jns    3e5 <printint+0x2b>
    neg = 1;
 3d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	f7 d8                	neg    %eax
 3e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e3:	eb 06                	jmp    3eb <printint+0x31>
  } else {
    x = xx;
 3e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f5:	8d 41 01             	lea    0x1(%ecx),%eax
 3f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 401:	ba 00 00 00 00       	mov    $0x0,%edx
 406:	f7 f3                	div    %ebx
 408:	89 d0                	mov    %edx,%eax
 40a:	0f b6 80 48 0b 00 00 	movzbl 0xb48(%eax),%eax
 411:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 415:	8b 5d 10             	mov    0x10(%ebp),%ebx
 418:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41b:	ba 00 00 00 00       	mov    $0x0,%edx
 420:	f7 f3                	div    %ebx
 422:	89 45 ec             	mov    %eax,-0x14(%ebp)
 425:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 429:	75 c7                	jne    3f2 <printint+0x38>
  if(neg)
 42b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42f:	74 2d                	je     45e <printint+0xa4>
    buf[i++] = '-';
 431:	8b 45 f4             	mov    -0xc(%ebp),%eax
 434:	8d 50 01             	lea    0x1(%eax),%edx
 437:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 43f:	eb 1d                	jmp    45e <printint+0xa4>
    putc(fd, buf[i]);
 441:	8d 55 dc             	lea    -0x24(%ebp),%edx
 444:	8b 45 f4             	mov    -0xc(%ebp),%eax
 447:	01 d0                	add    %edx,%eax
 449:	0f b6 00             	movzbl (%eax),%eax
 44c:	0f be c0             	movsbl %al,%eax
 44f:	83 ec 08             	sub    $0x8,%esp
 452:	50                   	push   %eax
 453:	ff 75 08             	pushl  0x8(%ebp)
 456:	e8 3c ff ff ff       	call   397 <putc>
 45b:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 45e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 466:	79 d9                	jns    441 <printint+0x87>
}
 468:	90                   	nop
 469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 46c:	c9                   	leave  
 46d:	c3                   	ret    

0000046e <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	83 ec 28             	sub    $0x28,%esp
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	89 45 e0             	mov    %eax,-0x20(%ebp)
 47a:	8b 45 10             	mov    0x10(%ebp),%eax
 47d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 480:	8b 45 e0             	mov    -0x20(%ebp),%eax
 483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 486:	89 d0                	mov    %edx,%eax
 488:	31 d2                	xor    %edx,%edx
 48a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 48d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 490:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 497:	74 13                	je     4ac <printlong+0x3e>
 499:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49c:	6a 00                	push   $0x0
 49e:	6a 10                	push   $0x10
 4a0:	50                   	push   %eax
 4a1:	ff 75 08             	pushl  0x8(%ebp)
 4a4:	e8 11 ff ff ff       	call   3ba <printint>
 4a9:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 4ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4af:	6a 00                	push   $0x0
 4b1:	6a 10                	push   $0x10
 4b3:	50                   	push   %eax
 4b4:	ff 75 08             	pushl  0x8(%ebp)
 4b7:	e8 fe fe ff ff       	call   3ba <printint>
 4bc:	83 c4 10             	add    $0x10,%esp
}
 4bf:	90                   	nop
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

000004c2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4cf:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d2:	83 c0 04             	add    $0x4,%eax
 4d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4df:	e9 88 01 00 00       	jmp    66c <printf+0x1aa>
    c = fmt[i] & 0xff;
 4e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ea:	01 d0                	add    %edx,%eax
 4ec:	0f b6 00             	movzbl (%eax),%eax
 4ef:	0f be c0             	movsbl %al,%eax
 4f2:	25 ff 00 00 00       	and    $0xff,%eax
 4f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fe:	75 2c                	jne    52c <printf+0x6a>
      if(c == '%'){
 500:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 504:	75 0c                	jne    512 <printf+0x50>
        state = '%';
 506:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 50d:	e9 56 01 00 00       	jmp    668 <printf+0x1a6>
      } else {
        putc(fd, c);
 512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	83 ec 08             	sub    $0x8,%esp
 51b:	50                   	push   %eax
 51c:	ff 75 08             	pushl  0x8(%ebp)
 51f:	e8 73 fe ff ff       	call   397 <putc>
 524:	83 c4 10             	add    $0x10,%esp
 527:	e9 3c 01 00 00       	jmp    668 <printf+0x1a6>
      }
    } else if(state == '%'){
 52c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 530:	0f 85 32 01 00 00    	jne    668 <printf+0x1a6>
      if(c == 'd'){
 536:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 53a:	75 1e                	jne    55a <printf+0x98>
        printint(fd, *ap, 10, 1);
 53c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53f:	8b 00                	mov    (%eax),%eax
 541:	6a 01                	push   $0x1
 543:	6a 0a                	push   $0xa
 545:	50                   	push   %eax
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 6c fe ff ff       	call   3ba <printint>
 54e:	83 c4 10             	add    $0x10,%esp
        ap++;
 551:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 555:	e9 07 01 00 00       	jmp    661 <printf+0x19f>
      } else if(c == 'l') {
 55a:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 55e:	75 29                	jne    589 <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 560:	8b 45 e8             	mov    -0x18(%ebp),%eax
 563:	8b 50 04             	mov    0x4(%eax),%edx
 566:	8b 00                	mov    (%eax),%eax
 568:	83 ec 0c             	sub    $0xc,%esp
 56b:	6a 00                	push   $0x0
 56d:	6a 0a                	push   $0xa
 56f:	52                   	push   %edx
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 f5 fe ff ff       	call   46e <printlong>
 579:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 584:	e9 d8 00 00 00       	jmp    661 <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 589:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58d:	74 06                	je     595 <printf+0xd3>
 58f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 593:	75 1e                	jne    5b3 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 595:	8b 45 e8             	mov    -0x18(%ebp),%eax
 598:	8b 00                	mov    (%eax),%eax
 59a:	6a 00                	push   $0x0
 59c:	6a 10                	push   $0x10
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 13 fe ff ff       	call   3ba <printint>
 5a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ae:	e9 ae 00 00 00       	jmp    661 <printf+0x19f>
      } else if(c == 's'){
 5b3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b7:	75 43                	jne    5fc <printf+0x13a>
        s = (char*)*ap;
 5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c9:	75 25                	jne    5f0 <printf+0x12e>
          s = "(null)";
 5cb:	c7 45 f4 d4 08 00 00 	movl   $0x8d4,-0xc(%ebp)
        while(*s != 0){
 5d2:	eb 1c                	jmp    5f0 <printf+0x12e>
          putc(fd, *s);
 5d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d7:	0f b6 00             	movzbl (%eax),%eax
 5da:	0f be c0             	movsbl %al,%eax
 5dd:	83 ec 08             	sub    $0x8,%esp
 5e0:	50                   	push   %eax
 5e1:	ff 75 08             	pushl  0x8(%ebp)
 5e4:	e8 ae fd ff ff       	call   397 <putc>
 5e9:	83 c4 10             	add    $0x10,%esp
          s++;
 5ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f3:	0f b6 00             	movzbl (%eax),%eax
 5f6:	84 c0                	test   %al,%al
 5f8:	75 da                	jne    5d4 <printf+0x112>
 5fa:	eb 65                	jmp    661 <printf+0x19f>
        }
      } else if(c == 'c'){
 5fc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 600:	75 1d                	jne    61f <printf+0x15d>
        putc(fd, *ap);
 602:	8b 45 e8             	mov    -0x18(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	0f be c0             	movsbl %al,%eax
 60a:	83 ec 08             	sub    $0x8,%esp
 60d:	50                   	push   %eax
 60e:	ff 75 08             	pushl  0x8(%ebp)
 611:	e8 81 fd ff ff       	call   397 <putc>
 616:	83 c4 10             	add    $0x10,%esp
        ap++;
 619:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61d:	eb 42                	jmp    661 <printf+0x19f>
      } else if(c == '%'){
 61f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 623:	75 17                	jne    63c <printf+0x17a>
        putc(fd, c);
 625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	50                   	push   %eax
 62f:	ff 75 08             	pushl  0x8(%ebp)
 632:	e8 60 fd ff ff       	call   397 <putc>
 637:	83 c4 10             	add    $0x10,%esp
 63a:	eb 25                	jmp    661 <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63c:	83 ec 08             	sub    $0x8,%esp
 63f:	6a 25                	push   $0x25
 641:	ff 75 08             	pushl  0x8(%ebp)
 644:	e8 4e fd ff ff       	call   397 <putc>
 649:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 64c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	83 ec 08             	sub    $0x8,%esp
 655:	50                   	push   %eax
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 39 fd ff ff       	call   397 <putc>
 65e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 661:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 668:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 66c:	8b 55 0c             	mov    0xc(%ebp),%edx
 66f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 672:	01 d0                	add    %edx,%eax
 674:	0f b6 00             	movzbl (%eax),%eax
 677:	84 c0                	test   %al,%al
 679:	0f 85 65 fe ff ff    	jne    4e4 <printf+0x22>
    }
  }
}
 67f:	90                   	nop
 680:	c9                   	leave  
 681:	c3                   	ret    

00000682 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 682:	55                   	push   %ebp
 683:	89 e5                	mov    %esp,%ebp
 685:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 688:	8b 45 08             	mov    0x8(%ebp),%eax
 68b:	83 e8 08             	sub    $0x8,%eax
 68e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	a1 64 0b 00 00       	mov    0xb64,%eax
 696:	89 45 fc             	mov    %eax,-0x4(%ebp)
 699:	eb 24                	jmp    6bf <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a3:	77 12                	ja     6b7 <free+0x35>
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ab:	77 24                	ja     6d1 <free+0x4f>
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b5:	77 1a                	ja     6d1 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c5:	76 d4                	jbe    69b <free+0x19>
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cf:	76 ca                	jbe    69b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	01 c2                	add    %eax,%edx
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	39 c2                	cmp    %eax,%edx
 6ea:	75 24                	jne    710 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 00                	mov    (%eax),%eax
 6f7:	8b 40 04             	mov    0x4(%eax),%eax
 6fa:	01 c2                	add    %eax,%edx
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	8b 10                	mov    (%eax),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	89 10                	mov    %edx,(%eax)
 70e:	eb 0a                	jmp    71a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 10                	mov    (%eax),%edx
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	01 d0                	add    %edx,%eax
 72c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72f:	75 20                	jne    751 <free+0xcf>
    p->s.size += bp->s.size;
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 50 04             	mov    0x4(%eax),%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	01 c2                	add    %eax,%edx
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	8b 10                	mov    (%eax),%edx
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	89 10                	mov    %edx,(%eax)
 74f:	eb 08                	jmp    759 <free+0xd7>
  } else
    p->s.ptr = bp;
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 55 f8             	mov    -0x8(%ebp),%edx
 757:	89 10                	mov    %edx,(%eax)
  freep = p;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	a3 64 0b 00 00       	mov    %eax,0xb64
}
 761:	90                   	nop
 762:	c9                   	leave  
 763:	c3                   	ret    

00000764 <morecore>:

static Header*
morecore(uint nu)
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 771:	77 07                	ja     77a <morecore+0x16>
    nu = 4096;
 773:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77a:	8b 45 08             	mov    0x8(%ebp),%eax
 77d:	c1 e0 03             	shl    $0x3,%eax
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	50                   	push   %eax
 784:	e8 e6 fb ff ff       	call   36f <sbrk>
 789:	83 c4 10             	add    $0x10,%esp
 78c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 793:	75 07                	jne    79c <morecore+0x38>
    return 0;
 795:	b8 00 00 00 00       	mov    $0x0,%eax
 79a:	eb 26                	jmp    7c2 <morecore+0x5e>
  hp = (Header*)p;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	8b 55 08             	mov    0x8(%ebp),%edx
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	83 c0 08             	add    $0x8,%eax
 7b1:	83 ec 0c             	sub    $0xc,%esp
 7b4:	50                   	push   %eax
 7b5:	e8 c8 fe ff ff       	call   682 <free>
 7ba:	83 c4 10             	add    $0x10,%esp
  return freep;
 7bd:	a1 64 0b 00 00       	mov    0xb64,%eax
}
 7c2:	c9                   	leave  
 7c3:	c3                   	ret    

000007c4 <malloc>:

void*
malloc(uint nbytes)
{
 7c4:	55                   	push   %ebp
 7c5:	89 e5                	mov    %esp,%ebp
 7c7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ca:	8b 45 08             	mov    0x8(%ebp),%eax
 7cd:	83 c0 07             	add    $0x7,%eax
 7d0:	c1 e8 03             	shr    $0x3,%eax
 7d3:	83 c0 01             	add    $0x1,%eax
 7d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d9:	a1 64 0b 00 00       	mov    0xb64,%eax
 7de:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e5:	75 23                	jne    80a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e7:	c7 45 f0 5c 0b 00 00 	movl   $0xb5c,-0x10(%ebp)
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	a3 64 0b 00 00       	mov    %eax,0xb64
 7f6:	a1 64 0b 00 00       	mov    0xb64,%eax
 7fb:	a3 5c 0b 00 00       	mov    %eax,0xb5c
    base.s.size = 0;
 800:	c7 05 60 0b 00 00 00 	movl   $0x0,0xb60
 807:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	8b 40 04             	mov    0x4(%eax),%eax
 818:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81b:	72 4d                	jb     86a <malloc+0xa6>
      if(p->s.size == nunits)
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 826:	75 0c                	jne    834 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 10                	mov    (%eax),%edx
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	89 10                	mov    %edx,(%eax)
 832:	eb 26                	jmp    85a <malloc+0x96>
      else {
        p->s.size -= nunits;
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83d:	89 c2                	mov    %eax,%edx
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 40 04             	mov    0x4(%eax),%eax
 84b:	c1 e0 03             	shl    $0x3,%eax
 84e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	8b 55 ec             	mov    -0x14(%ebp),%edx
 857:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85d:	a3 64 0b 00 00       	mov    %eax,0xb64
      return (void*)(p + 1);
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	83 c0 08             	add    $0x8,%eax
 868:	eb 3b                	jmp    8a5 <malloc+0xe1>
    }
    if(p == freep)
 86a:	a1 64 0b 00 00       	mov    0xb64,%eax
 86f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 872:	75 1e                	jne    892 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 874:	83 ec 0c             	sub    $0xc,%esp
 877:	ff 75 ec             	pushl  -0x14(%ebp)
 87a:	e8 e5 fe ff ff       	call   764 <morecore>
 87f:	83 c4 10             	add    $0x10,%esp
 882:	89 45 f4             	mov    %eax,-0xc(%ebp)
 885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 889:	75 07                	jne    892 <malloc+0xce>
        return 0;
 88b:	b8 00 00 00 00       	mov    $0x0,%eax
 890:	eb 13                	jmp    8a5 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	89 45 f0             	mov    %eax,-0x10(%ebp)
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a0:	e9 6d ff ff ff       	jmp    812 <malloc+0x4e>
  }
}
 8a5:	c9                   	leave  
 8a6:	c3                   	ret    
