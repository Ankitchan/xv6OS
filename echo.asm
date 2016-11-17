
_echo:     file format elf32-i386


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

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba 7c 08 00 00       	mov    $0x87c,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 7e 08 00 00       	mov    $0x87e,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 80 08 00 00       	push   $0x880
  4b:	6a 01                	push   $0x1
  4d:	e8 45 04 00 00       	call   497 <printf>
  52:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
  exit();
  60:	e8 57 02 00 00       	call   2bc <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 47 01 00 00       	call   2d4 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
      break;
 1cc:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 0c 01 00 00       	call   2fc <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 03 01 00 00       	call   314 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 c2 00 00 00       	call   2e4 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	8d 50 01             	lea    0x1(%eax),%edx
 291:	89 55 fc             	mov    %edx,-0x4(%ebp)
 294:	8b 55 f8             	mov    -0x8(%ebp),%edx
 297:	8d 4a 01             	lea    0x1(%edx),%ecx
 29a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b4:	b8 01 00 00 00       	mov    $0x1,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <exit>:
SYSCALL(exit)
 2bc:	b8 02 00 00 00       	mov    $0x2,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <wait>:
SYSCALL(wait)
 2c4:	b8 03 00 00 00       	mov    $0x3,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <pipe>:
SYSCALL(pipe)
 2cc:	b8 04 00 00 00       	mov    $0x4,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <read>:
SYSCALL(read)
 2d4:	b8 05 00 00 00       	mov    $0x5,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <write>:
SYSCALL(write)
 2dc:	b8 10 00 00 00       	mov    $0x10,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <close>:
SYSCALL(close)
 2e4:	b8 15 00 00 00       	mov    $0x15,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <kill>:
SYSCALL(kill)
 2ec:	b8 06 00 00 00       	mov    $0x6,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <exec>:
SYSCALL(exec)
 2f4:	b8 07 00 00 00       	mov    $0x7,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <open>:
SYSCALL(open)
 2fc:	b8 0f 00 00 00       	mov    $0xf,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mknod>:
SYSCALL(mknod)
 304:	b8 11 00 00 00       	mov    $0x11,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <unlink>:
SYSCALL(unlink)
 30c:	b8 12 00 00 00       	mov    $0x12,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <fstat>:
SYSCALL(fstat)
 314:	b8 08 00 00 00       	mov    $0x8,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <link>:
SYSCALL(link)
 31c:	b8 13 00 00 00       	mov    $0x13,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <mkdir>:
SYSCALL(mkdir)
 324:	b8 14 00 00 00       	mov    $0x14,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <chdir>:
SYSCALL(chdir)
 32c:	b8 09 00 00 00       	mov    $0x9,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <dup>:
SYSCALL(dup)
 334:	b8 0a 00 00 00       	mov    $0xa,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <getpid>:
SYSCALL(getpid)
 33c:	b8 0b 00 00 00       	mov    $0xb,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sbrk>:
SYSCALL(sbrk)
 344:	b8 0c 00 00 00       	mov    $0xc,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sleep>:
SYSCALL(sleep)
 34c:	b8 0d 00 00 00       	mov    $0xd,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <uptime>:
SYSCALL(uptime)
 354:	b8 0e 00 00 00       	mov    $0xe,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <gettime>:
SYSCALL(gettime)
 35c:	b8 16 00 00 00       	mov    $0x16,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <settickets>:
SYSCALL(settickets)
 364:	b8 17 00 00 00       	mov    $0x17,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 18             	sub    $0x18,%esp
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 378:	83 ec 04             	sub    $0x4,%esp
 37b:	6a 01                	push   $0x1
 37d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 380:	50                   	push   %eax
 381:	ff 75 08             	pushl  0x8(%ebp)
 384:	e8 53 ff ff ff       	call   2dc <write>
 389:	83 c4 10             	add    $0x10,%esp
}
 38c:	90                   	nop
 38d:	c9                   	leave  
 38e:	c3                   	ret    

0000038f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38f:	55                   	push   %ebp
 390:	89 e5                	mov    %esp,%ebp
 392:	53                   	push   %ebx
 393:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 396:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a1:	74 17                	je     3ba <printint+0x2b>
 3a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a7:	79 11                	jns    3ba <printint+0x2b>
    neg = 1;
 3a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	f7 d8                	neg    %eax
 3b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b8:	eb 06                	jmp    3c0 <printint+0x31>
  } else {
    x = xx;
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3ca:	8d 41 01             	lea    0x1(%ecx),%eax
 3cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d6:	ba 00 00 00 00       	mov    $0x0,%edx
 3db:	f7 f3                	div    %ebx
 3dd:	89 d0                	mov    %edx,%eax
 3df:	0f b6 80 f8 0a 00 00 	movzbl 0xaf8(%eax),%eax
 3e6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f0:	ba 00 00 00 00       	mov    $0x0,%edx
 3f5:	f7 f3                	div    %ebx
 3f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fe:	75 c7                	jne    3c7 <printint+0x38>
  if(neg)
 400:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 404:	74 2d                	je     433 <printint+0xa4>
    buf[i++] = '-';
 406:	8b 45 f4             	mov    -0xc(%ebp),%eax
 409:	8d 50 01             	lea    0x1(%eax),%edx
 40c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 414:	eb 1d                	jmp    433 <printint+0xa4>
    putc(fd, buf[i]);
 416:	8d 55 dc             	lea    -0x24(%ebp),%edx
 419:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41c:	01 d0                	add    %edx,%eax
 41e:	0f b6 00             	movzbl (%eax),%eax
 421:	0f be c0             	movsbl %al,%eax
 424:	83 ec 08             	sub    $0x8,%esp
 427:	50                   	push   %eax
 428:	ff 75 08             	pushl  0x8(%ebp)
 42b:	e8 3c ff ff ff       	call   36c <putc>
 430:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 433:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43b:	79 d9                	jns    416 <printint+0x87>
}
 43d:	90                   	nop
 43e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 441:	c9                   	leave  
 442:	c3                   	ret    

00000443 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 443:	55                   	push   %ebp
 444:	89 e5                	mov    %esp,%ebp
 446:	83 ec 28             	sub    $0x28,%esp
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 44f:	8b 45 10             	mov    0x10(%ebp),%eax
 452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 455:	8b 45 e0             	mov    -0x20(%ebp),%eax
 458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 45b:	89 d0                	mov    %edx,%eax
 45d:	31 d2                	xor    %edx,%edx
 45f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 462:	8b 45 e0             	mov    -0x20(%ebp),%eax
 465:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46c:	74 13                	je     481 <printlong+0x3e>
 46e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 471:	6a 00                	push   $0x0
 473:	6a 10                	push   $0x10
 475:	50                   	push   %eax
 476:	ff 75 08             	pushl  0x8(%ebp)
 479:	e8 11 ff ff ff       	call   38f <printint>
 47e:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 481:	8b 45 f0             	mov    -0x10(%ebp),%eax
 484:	6a 00                	push   $0x0
 486:	6a 10                	push   $0x10
 488:	50                   	push   %eax
 489:	ff 75 08             	pushl  0x8(%ebp)
 48c:	e8 fe fe ff ff       	call   38f <printint>
 491:	83 c4 10             	add    $0x10,%esp
}
 494:	90                   	nop
 495:	c9                   	leave  
 496:	c3                   	ret    

00000497 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 497:	55                   	push   %ebp
 498:	89 e5                	mov    %esp,%ebp
 49a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 49d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a7:	83 c0 04             	add    $0x4,%eax
 4aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b4:	e9 88 01 00 00       	jmp    641 <printf+0x1aa>
    c = fmt[i] & 0xff;
 4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	0f b6 00             	movzbl (%eax),%eax
 4c4:	0f be c0             	movsbl %al,%eax
 4c7:	25 ff 00 00 00       	and    $0xff,%eax
 4cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d3:	75 2c                	jne    501 <printf+0x6a>
      if(c == '%'){
 4d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d9:	75 0c                	jne    4e7 <printf+0x50>
        state = '%';
 4db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e2:	e9 56 01 00 00       	jmp    63d <printf+0x1a6>
      } else {
        putc(fd, c);
 4e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ea:	0f be c0             	movsbl %al,%eax
 4ed:	83 ec 08             	sub    $0x8,%esp
 4f0:	50                   	push   %eax
 4f1:	ff 75 08             	pushl  0x8(%ebp)
 4f4:	e8 73 fe ff ff       	call   36c <putc>
 4f9:	83 c4 10             	add    $0x10,%esp
 4fc:	e9 3c 01 00 00       	jmp    63d <printf+0x1a6>
      }
    } else if(state == '%'){
 501:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 505:	0f 85 32 01 00 00    	jne    63d <printf+0x1a6>
      if(c == 'd'){
 50b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50f:	75 1e                	jne    52f <printf+0x98>
        printint(fd, *ap, 10, 1);
 511:	8b 45 e8             	mov    -0x18(%ebp),%eax
 514:	8b 00                	mov    (%eax),%eax
 516:	6a 01                	push   $0x1
 518:	6a 0a                	push   $0xa
 51a:	50                   	push   %eax
 51b:	ff 75 08             	pushl  0x8(%ebp)
 51e:	e8 6c fe ff ff       	call   38f <printint>
 523:	83 c4 10             	add    $0x10,%esp
        ap++;
 526:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52a:	e9 07 01 00 00       	jmp    636 <printf+0x19f>
      } else if(c == 'l') {
 52f:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 533:	75 29                	jne    55e <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 50 04             	mov    0x4(%eax),%edx
 53b:	8b 00                	mov    (%eax),%eax
 53d:	83 ec 0c             	sub    $0xc,%esp
 540:	6a 00                	push   $0x0
 542:	6a 0a                	push   $0xa
 544:	52                   	push   %edx
 545:	50                   	push   %eax
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 f5 fe ff ff       	call   443 <printlong>
 54e:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 551:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 559:	e9 d8 00 00 00       	jmp    636 <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 55e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 562:	74 06                	je     56a <printf+0xd3>
 564:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 568:	75 1e                	jne    588 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 56a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56d:	8b 00                	mov    (%eax),%eax
 56f:	6a 00                	push   $0x0
 571:	6a 10                	push   $0x10
 573:	50                   	push   %eax
 574:	ff 75 08             	pushl  0x8(%ebp)
 577:	e8 13 fe ff ff       	call   38f <printint>
 57c:	83 c4 10             	add    $0x10,%esp
        ap++;
 57f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 583:	e9 ae 00 00 00       	jmp    636 <printf+0x19f>
      } else if(c == 's'){
 588:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58c:	75 43                	jne    5d1 <printf+0x13a>
        s = (char*)*ap;
 58e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 591:	8b 00                	mov    (%eax),%eax
 593:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59e:	75 25                	jne    5c5 <printf+0x12e>
          s = "(null)";
 5a0:	c7 45 f4 85 08 00 00 	movl   $0x885,-0xc(%ebp)
        while(*s != 0){
 5a7:	eb 1c                	jmp    5c5 <printf+0x12e>
          putc(fd, *s);
 5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	83 ec 08             	sub    $0x8,%esp
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 ae fd ff ff       	call   36c <putc>
 5be:	83 c4 10             	add    $0x10,%esp
          s++;
 5c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	84 c0                	test   %al,%al
 5cd:	75 da                	jne    5a9 <printf+0x112>
 5cf:	eb 65                	jmp    636 <printf+0x19f>
        }
      } else if(c == 'c'){
 5d1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d5:	75 1d                	jne    5f4 <printf+0x15d>
        putc(fd, *ap);
 5d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	83 ec 08             	sub    $0x8,%esp
 5e2:	50                   	push   %eax
 5e3:	ff 75 08             	pushl  0x8(%ebp)
 5e6:	e8 81 fd ff ff       	call   36c <putc>
 5eb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f2:	eb 42                	jmp    636 <printf+0x19f>
      } else if(c == '%'){
 5f4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f8:	75 17                	jne    611 <printf+0x17a>
        putc(fd, c);
 5fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fd:	0f be c0             	movsbl %al,%eax
 600:	83 ec 08             	sub    $0x8,%esp
 603:	50                   	push   %eax
 604:	ff 75 08             	pushl  0x8(%ebp)
 607:	e8 60 fd ff ff       	call   36c <putc>
 60c:	83 c4 10             	add    $0x10,%esp
 60f:	eb 25                	jmp    636 <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 611:	83 ec 08             	sub    $0x8,%esp
 614:	6a 25                	push   $0x25
 616:	ff 75 08             	pushl  0x8(%ebp)
 619:	e8 4e fd ff ff       	call   36c <putc>
 61e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 624:	0f be c0             	movsbl %al,%eax
 627:	83 ec 08             	sub    $0x8,%esp
 62a:	50                   	push   %eax
 62b:	ff 75 08             	pushl  0x8(%ebp)
 62e:	e8 39 fd ff ff       	call   36c <putc>
 633:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 63d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 641:	8b 55 0c             	mov    0xc(%ebp),%edx
 644:	8b 45 f0             	mov    -0x10(%ebp),%eax
 647:	01 d0                	add    %edx,%eax
 649:	0f b6 00             	movzbl (%eax),%eax
 64c:	84 c0                	test   %al,%al
 64e:	0f 85 65 fe ff ff    	jne    4b9 <printf+0x22>
    }
  }
}
 654:	90                   	nop
 655:	c9                   	leave  
 656:	c3                   	ret    

00000657 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 657:	55                   	push   %ebp
 658:	89 e5                	mov    %esp,%ebp
 65a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	83 e8 08             	sub    $0x8,%eax
 663:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 666:	a1 14 0b 00 00       	mov    0xb14,%eax
 66b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66e:	eb 24                	jmp    694 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 678:	77 12                	ja     68c <free+0x35>
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 680:	77 24                	ja     6a6 <free+0x4f>
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68a:	77 1a                	ja     6a6 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	89 45 fc             	mov    %eax,-0x4(%ebp)
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69a:	76 d4                	jbe    670 <free+0x19>
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a4:	76 ca                	jbe    670 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	8b 40 04             	mov    0x4(%eax),%eax
 6ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	01 c2                	add    %eax,%edx
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	39 c2                	cmp    %eax,%edx
 6bf:	75 24                	jne    6e5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	8b 50 04             	mov    0x4(%eax),%edx
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	8b 40 04             	mov    0x4(%eax),%eax
 6cf:	01 c2                	add    %eax,%edx
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	8b 10                	mov    (%eax),%edx
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	89 10                	mov    %edx,(%eax)
 6e3:	eb 0a                	jmp    6ef <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 10                	mov    (%eax),%edx
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 40 04             	mov    0x4(%eax),%eax
 6f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	01 d0                	add    %edx,%eax
 701:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 704:	75 20                	jne    726 <free+0xcf>
    p->s.size += bp->s.size;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	8b 50 04             	mov    0x4(%eax),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	8b 40 04             	mov    0x4(%eax),%eax
 712:	01 c2                	add    %eax,%edx
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 10                	mov    (%eax),%edx
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	89 10                	mov    %edx,(%eax)
 724:	eb 08                	jmp    72e <free+0xd7>
  } else
    p->s.ptr = bp;
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72c:	89 10                	mov    %edx,(%eax)
  freep = p;
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	a3 14 0b 00 00       	mov    %eax,0xb14
}
 736:	90                   	nop
 737:	c9                   	leave  
 738:	c3                   	ret    

00000739 <morecore>:

static Header*
morecore(uint nu)
{
 739:	55                   	push   %ebp
 73a:	89 e5                	mov    %esp,%ebp
 73c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 73f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 746:	77 07                	ja     74f <morecore+0x16>
    nu = 4096;
 748:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 74f:	8b 45 08             	mov    0x8(%ebp),%eax
 752:	c1 e0 03             	shl    $0x3,%eax
 755:	83 ec 0c             	sub    $0xc,%esp
 758:	50                   	push   %eax
 759:	e8 e6 fb ff ff       	call   344 <sbrk>
 75e:	83 c4 10             	add    $0x10,%esp
 761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 764:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 768:	75 07                	jne    771 <morecore+0x38>
    return 0;
 76a:	b8 00 00 00 00       	mov    $0x0,%eax
 76f:	eb 26                	jmp    797 <morecore+0x5e>
  hp = (Header*)p;
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	8b 55 08             	mov    0x8(%ebp),%edx
 77d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	83 c0 08             	add    $0x8,%eax
 786:	83 ec 0c             	sub    $0xc,%esp
 789:	50                   	push   %eax
 78a:	e8 c8 fe ff ff       	call   657 <free>
 78f:	83 c4 10             	add    $0x10,%esp
  return freep;
 792:	a1 14 0b 00 00       	mov    0xb14,%eax
}
 797:	c9                   	leave  
 798:	c3                   	ret    

00000799 <malloc>:

void*
malloc(uint nbytes)
{
 799:	55                   	push   %ebp
 79a:	89 e5                	mov    %esp,%ebp
 79c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79f:	8b 45 08             	mov    0x8(%ebp),%eax
 7a2:	83 c0 07             	add    $0x7,%eax
 7a5:	c1 e8 03             	shr    $0x3,%eax
 7a8:	83 c0 01             	add    $0x1,%eax
 7ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ae:	a1 14 0b 00 00       	mov    0xb14,%eax
 7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ba:	75 23                	jne    7df <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7bc:	c7 45 f0 0c 0b 00 00 	movl   $0xb0c,-0x10(%ebp)
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	a3 14 0b 00 00       	mov    %eax,0xb14
 7cb:	a1 14 0b 00 00       	mov    0xb14,%eax
 7d0:	a3 0c 0b 00 00       	mov    %eax,0xb0c
    base.s.size = 0;
 7d5:	c7 05 10 0b 00 00 00 	movl   $0x0,0xb10
 7dc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f0:	72 4d                	jb     83f <malloc+0xa6>
      if(p->s.size == nunits)
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fb:	75 0c                	jne    809 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 10                	mov    (%eax),%edx
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	89 10                	mov    %edx,(%eax)
 807:	eb 26                	jmp    82f <malloc+0x96>
      else {
        p->s.size -= nunits;
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	8b 40 04             	mov    0x4(%eax),%eax
 80f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 812:	89 c2                	mov    %eax,%edx
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	8b 40 04             	mov    0x4(%eax),%eax
 820:	c1 e0 03             	shl    $0x3,%eax
 823:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	a3 14 0b 00 00       	mov    %eax,0xb14
      return (void*)(p + 1);
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	83 c0 08             	add    $0x8,%eax
 83d:	eb 3b                	jmp    87a <malloc+0xe1>
    }
    if(p == freep)
 83f:	a1 14 0b 00 00       	mov    0xb14,%eax
 844:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 847:	75 1e                	jne    867 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 849:	83 ec 0c             	sub    $0xc,%esp
 84c:	ff 75 ec             	pushl  -0x14(%ebp)
 84f:	e8 e5 fe ff ff       	call   739 <morecore>
 854:	83 c4 10             	add    $0x10,%esp
 857:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85e:	75 07                	jne    867 <malloc+0xce>
        return 0;
 860:	b8 00 00 00 00       	mov    $0x0,%eax
 865:	eb 13                	jmp    87a <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 875:	e9 6d ff ff ff       	jmp    7e7 <malloc+0x4e>
  }
}
 87a:	c9                   	leave  
 87b:	c3                   	ret    
