
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 20 0c 00 00       	push   $0xc20
  13:	6a 01                	push   $0x1
  15:	e8 6c 03 00 00       	call   386 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 20 0c 00 00       	push   $0xc20
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 4c 03 00 00       	call   37e <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 26 09 00 00       	push   $0x926
  4c:	6a 01                	push   $0x1
  4e:	e8 ee 04 00 00       	call   541 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 0b 03 00 00       	call   366 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 dd 02 00 00       	call   366 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 f8 02 00 00       	call   3a6 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 37 09 00 00       	push   $0x937
  d4:	6a 01                	push   $0x1
  d6:	e8 66 04 00 00       	call   541 <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 83 02 00 00       	call   366 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 92 02 00 00       	call   38e <close>
  fc:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
  }
  exit();
 10a:	e8 57 02 00 00       	call   366 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 47 01 00 00       	call   37e <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b3                	jl     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
      break;
 276:	90                   	nop
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 0c 01 00 00       	call   3a6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 03 01 00 00       	call   3be <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 c2 00 00 00       	call   38e <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 341:	8d 4a 01             	lea    0x1(%edx),%ecx
 344:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35e:	b8 01 00 00 00       	mov    $0x1,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <exit>:
SYSCALL(exit)
 366:	b8 02 00 00 00       	mov    $0x2,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <wait>:
SYSCALL(wait)
 36e:	b8 03 00 00 00       	mov    $0x3,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <pipe>:
SYSCALL(pipe)
 376:	b8 04 00 00 00       	mov    $0x4,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <read>:
SYSCALL(read)
 37e:	b8 05 00 00 00       	mov    $0x5,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <write>:
SYSCALL(write)
 386:	b8 10 00 00 00       	mov    $0x10,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <close>:
SYSCALL(close)
 38e:	b8 15 00 00 00       	mov    $0x15,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <kill>:
SYSCALL(kill)
 396:	b8 06 00 00 00       	mov    $0x6,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exec>:
SYSCALL(exec)
 39e:	b8 07 00 00 00       	mov    $0x7,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <open>:
SYSCALL(open)
 3a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mknod>:
SYSCALL(mknod)
 3ae:	b8 11 00 00 00       	mov    $0x11,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <unlink>:
SYSCALL(unlink)
 3b6:	b8 12 00 00 00       	mov    $0x12,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <fstat>:
SYSCALL(fstat)
 3be:	b8 08 00 00 00       	mov    $0x8,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <link>:
SYSCALL(link)
 3c6:	b8 13 00 00 00       	mov    $0x13,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mkdir>:
SYSCALL(mkdir)
 3ce:	b8 14 00 00 00       	mov    $0x14,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chdir>:
SYSCALL(chdir)
 3d6:	b8 09 00 00 00       	mov    $0x9,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <dup>:
SYSCALL(dup)
 3de:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getpid>:
SYSCALL(getpid)
 3e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <sbrk>:
SYSCALL(sbrk)
 3ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sleep>:
SYSCALL(sleep)
 3f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <uptime>:
SYSCALL(uptime)
 3fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <gettime>:
SYSCALL(gettime)
 406:	b8 16 00 00 00       	mov    $0x16,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <settickets>:
SYSCALL(settickets)
 40e:	b8 17 00 00 00       	mov    $0x17,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
 419:	83 ec 18             	sub    $0x18,%esp
 41c:	8b 45 0c             	mov    0xc(%ebp),%eax
 41f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 422:	83 ec 04             	sub    $0x4,%esp
 425:	6a 01                	push   $0x1
 427:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42a:	50                   	push   %eax
 42b:	ff 75 08             	pushl  0x8(%ebp)
 42e:	e8 53 ff ff ff       	call   386 <write>
 433:	83 c4 10             	add    $0x10,%esp
}
 436:	90                   	nop
 437:	c9                   	leave  
 438:	c3                   	ret    

00000439 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 439:	55                   	push   %ebp
 43a:	89 e5                	mov    %esp,%ebp
 43c:	53                   	push   %ebx
 43d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 447:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 44b:	74 17                	je     464 <printint+0x2b>
 44d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 451:	79 11                	jns    464 <printint+0x2b>
    neg = 1;
 453:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	f7 d8                	neg    %eax
 45f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 462:	eb 06                	jmp    46a <printint+0x31>
  } else {
    x = xx;
 464:	8b 45 0c             	mov    0xc(%ebp),%eax
 467:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 46a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 471:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 474:	8d 41 01             	lea    0x1(%ecx),%eax
 477:	89 45 f4             	mov    %eax,-0xc(%ebp)
 47a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 480:	ba 00 00 00 00       	mov    $0x0,%edx
 485:	f7 f3                	div    %ebx
 487:	89 d0                	mov    %edx,%eax
 489:	0f b6 80 e0 0b 00 00 	movzbl 0xbe0(%eax),%eax
 490:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 494:	8b 5d 10             	mov    0x10(%ebp),%ebx
 497:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49a:	ba 00 00 00 00       	mov    $0x0,%edx
 49f:	f7 f3                	div    %ebx
 4a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a8:	75 c7                	jne    471 <printint+0x38>
  if(neg)
 4aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ae:	74 2d                	je     4dd <printint+0xa4>
    buf[i++] = '-';
 4b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b3:	8d 50 01             	lea    0x1(%eax),%edx
 4b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4be:	eb 1d                	jmp    4dd <printint+0xa4>
    putc(fd, buf[i]);
 4c0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c6:	01 d0                	add    %edx,%eax
 4c8:	0f b6 00             	movzbl (%eax),%eax
 4cb:	0f be c0             	movsbl %al,%eax
 4ce:	83 ec 08             	sub    $0x8,%esp
 4d1:	50                   	push   %eax
 4d2:	ff 75 08             	pushl  0x8(%ebp)
 4d5:	e8 3c ff ff ff       	call   416 <putc>
 4da:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e5:	79 d9                	jns    4c0 <printint+0x87>
}
 4e7:	90                   	nop
 4e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4eb:	c9                   	leave  
 4ec:	c3                   	ret    

000004ed <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 4ed:	55                   	push   %ebp
 4ee:	89 e5                	mov    %esp,%ebp
 4f0:	83 ec 28             	sub    $0x28,%esp
 4f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 4f9:	8b 45 10             	mov    0x10(%ebp),%eax
 4fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 4ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
 502:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 505:	89 d0                	mov    %edx,%eax
 507:	31 d2                	xor    %edx,%edx
 509:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 50c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 50f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 516:	74 13                	je     52b <printlong+0x3e>
 518:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51b:	6a 00                	push   $0x0
 51d:	6a 10                	push   $0x10
 51f:	50                   	push   %eax
 520:	ff 75 08             	pushl  0x8(%ebp)
 523:	e8 11 ff ff ff       	call   439 <printint>
 528:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 52b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52e:	6a 00                	push   $0x0
 530:	6a 10                	push   $0x10
 532:	50                   	push   %eax
 533:	ff 75 08             	pushl  0x8(%ebp)
 536:	e8 fe fe ff ff       	call   439 <printint>
 53b:	83 c4 10             	add    $0x10,%esp
}
 53e:	90                   	nop
 53f:	c9                   	leave  
 540:	c3                   	ret    

00000541 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 541:	55                   	push   %ebp
 542:	89 e5                	mov    %esp,%ebp
 544:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 547:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 54e:	8d 45 0c             	lea    0xc(%ebp),%eax
 551:	83 c0 04             	add    $0x4,%eax
 554:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 557:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 55e:	e9 88 01 00 00       	jmp    6eb <printf+0x1aa>
    c = fmt[i] & 0xff;
 563:	8b 55 0c             	mov    0xc(%ebp),%edx
 566:	8b 45 f0             	mov    -0x10(%ebp),%eax
 569:	01 d0                	add    %edx,%eax
 56b:	0f b6 00             	movzbl (%eax),%eax
 56e:	0f be c0             	movsbl %al,%eax
 571:	25 ff 00 00 00       	and    $0xff,%eax
 576:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 579:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57d:	75 2c                	jne    5ab <printf+0x6a>
      if(c == '%'){
 57f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 583:	75 0c                	jne    591 <printf+0x50>
        state = '%';
 585:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 58c:	e9 56 01 00 00       	jmp    6e7 <printf+0x1a6>
      } else {
        putc(fd, c);
 591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 594:	0f be c0             	movsbl %al,%eax
 597:	83 ec 08             	sub    $0x8,%esp
 59a:	50                   	push   %eax
 59b:	ff 75 08             	pushl  0x8(%ebp)
 59e:	e8 73 fe ff ff       	call   416 <putc>
 5a3:	83 c4 10             	add    $0x10,%esp
 5a6:	e9 3c 01 00 00       	jmp    6e7 <printf+0x1a6>
      }
    } else if(state == '%'){
 5ab:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5af:	0f 85 32 01 00 00    	jne    6e7 <printf+0x1a6>
      if(c == 'd'){
 5b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b9:	75 1e                	jne    5d9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	6a 01                	push   $0x1
 5c2:	6a 0a                	push   $0xa
 5c4:	50                   	push   %eax
 5c5:	ff 75 08             	pushl  0x8(%ebp)
 5c8:	e8 6c fe ff ff       	call   439 <printint>
 5cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d4:	e9 07 01 00 00       	jmp    6e0 <printf+0x19f>
      } else if(c == 'l') {
 5d9:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 5dd:	75 29                	jne    608 <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 5df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e2:	8b 50 04             	mov    0x4(%eax),%edx
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	83 ec 0c             	sub    $0xc,%esp
 5ea:	6a 00                	push   $0x0
 5ec:	6a 0a                	push   $0xa
 5ee:	52                   	push   %edx
 5ef:	50                   	push   %eax
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 f5 fe ff ff       	call   4ed <printlong>
 5f8:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 5fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 5ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 603:	e9 d8 00 00 00       	jmp    6e0 <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 608:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 60c:	74 06                	je     614 <printf+0xd3>
 60e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 612:	75 1e                	jne    632 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 614:	8b 45 e8             	mov    -0x18(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	6a 00                	push   $0x0
 61b:	6a 10                	push   $0x10
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 13 fe ff ff       	call   439 <printint>
 626:	83 c4 10             	add    $0x10,%esp
        ap++;
 629:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62d:	e9 ae 00 00 00       	jmp    6e0 <printf+0x19f>
      } else if(c == 's'){
 632:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 636:	75 43                	jne    67b <printf+0x13a>
        s = (char*)*ap;
 638:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 640:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 648:	75 25                	jne    66f <printf+0x12e>
          s = "(null)";
 64a:	c7 45 f4 4c 09 00 00 	movl   $0x94c,-0xc(%ebp)
        while(*s != 0){
 651:	eb 1c                	jmp    66f <printf+0x12e>
          putc(fd, *s);
 653:	8b 45 f4             	mov    -0xc(%ebp),%eax
 656:	0f b6 00             	movzbl (%eax),%eax
 659:	0f be c0             	movsbl %al,%eax
 65c:	83 ec 08             	sub    $0x8,%esp
 65f:	50                   	push   %eax
 660:	ff 75 08             	pushl  0x8(%ebp)
 663:	e8 ae fd ff ff       	call   416 <putc>
 668:	83 c4 10             	add    $0x10,%esp
          s++;
 66b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 66f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 672:	0f b6 00             	movzbl (%eax),%eax
 675:	84 c0                	test   %al,%al
 677:	75 da                	jne    653 <printf+0x112>
 679:	eb 65                	jmp    6e0 <printf+0x19f>
        }
      } else if(c == 'c'){
 67b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 67f:	75 1d                	jne    69e <printf+0x15d>
        putc(fd, *ap);
 681:	8b 45 e8             	mov    -0x18(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	0f be c0             	movsbl %al,%eax
 689:	83 ec 08             	sub    $0x8,%esp
 68c:	50                   	push   %eax
 68d:	ff 75 08             	pushl  0x8(%ebp)
 690:	e8 81 fd ff ff       	call   416 <putc>
 695:	83 c4 10             	add    $0x10,%esp
        ap++;
 698:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69c:	eb 42                	jmp    6e0 <printf+0x19f>
      } else if(c == '%'){
 69e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a2:	75 17                	jne    6bb <printf+0x17a>
        putc(fd, c);
 6a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a7:	0f be c0             	movsbl %al,%eax
 6aa:	83 ec 08             	sub    $0x8,%esp
 6ad:	50                   	push   %eax
 6ae:	ff 75 08             	pushl  0x8(%ebp)
 6b1:	e8 60 fd ff ff       	call   416 <putc>
 6b6:	83 c4 10             	add    $0x10,%esp
 6b9:	eb 25                	jmp    6e0 <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6bb:	83 ec 08             	sub    $0x8,%esp
 6be:	6a 25                	push   $0x25
 6c0:	ff 75 08             	pushl  0x8(%ebp)
 6c3:	e8 4e fd ff ff       	call   416 <putc>
 6c8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ce:	0f be c0             	movsbl %al,%eax
 6d1:	83 ec 08             	sub    $0x8,%esp
 6d4:	50                   	push   %eax
 6d5:	ff 75 08             	pushl  0x8(%ebp)
 6d8:	e8 39 fd ff ff       	call   416 <putc>
 6dd:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f1:	01 d0                	add    %edx,%eax
 6f3:	0f b6 00             	movzbl (%eax),%eax
 6f6:	84 c0                	test   %al,%al
 6f8:	0f 85 65 fe ff ff    	jne    563 <printf+0x22>
    }
  }
}
 6fe:	90                   	nop
 6ff:	c9                   	leave  
 700:	c3                   	ret    

00000701 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 701:	55                   	push   %ebp
 702:	89 e5                	mov    %esp,%ebp
 704:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 707:	8b 45 08             	mov    0x8(%ebp),%eax
 70a:	83 e8 08             	sub    $0x8,%eax
 70d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	a1 08 0c 00 00       	mov    0xc08,%eax
 715:	89 45 fc             	mov    %eax,-0x4(%ebp)
 718:	eb 24                	jmp    73e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 722:	77 12                	ja     736 <free+0x35>
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72a:	77 24                	ja     750 <free+0x4f>
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 734:	77 1a                	ja     750 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 744:	76 d4                	jbe    71a <free+0x19>
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74e:	76 ca                	jbe    71a <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	8b 40 04             	mov    0x4(%eax),%eax
 756:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	01 c2                	add    %eax,%edx
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	39 c2                	cmp    %eax,%edx
 769:	75 24                	jne    78f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	8b 50 04             	mov    0x4(%eax),%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	01 c2                	add    %eax,%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78b:	89 10                	mov    %edx,(%eax)
 78d:	eb 0a                	jmp    799 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 f8             	mov    -0x8(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	01 d0                	add    %edx,%eax
 7ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ae:	75 20                	jne    7d0 <free+0xcf>
    p->s.size += bp->s.size;
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	8b 50 04             	mov    0x4(%eax),%edx
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	01 c2                	add    %eax,%edx
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	8b 10                	mov    (%eax),%edx
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	89 10                	mov    %edx,(%eax)
 7ce:	eb 08                	jmp    7d8 <free+0xd7>
  } else
    p->s.ptr = bp;
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d6:	89 10                	mov    %edx,(%eax)
  freep = p;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	a3 08 0c 00 00       	mov    %eax,0xc08
}
 7e0:	90                   	nop
 7e1:	c9                   	leave  
 7e2:	c3                   	ret    

000007e3 <morecore>:

static Header*
morecore(uint nu)
{
 7e3:	55                   	push   %ebp
 7e4:	89 e5                	mov    %esp,%ebp
 7e6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f0:	77 07                	ja     7f9 <morecore+0x16>
    nu = 4096;
 7f2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f9:	8b 45 08             	mov    0x8(%ebp),%eax
 7fc:	c1 e0 03             	shl    $0x3,%eax
 7ff:	83 ec 0c             	sub    $0xc,%esp
 802:	50                   	push   %eax
 803:	e8 e6 fb ff ff       	call   3ee <sbrk>
 808:	83 c4 10             	add    $0x10,%esp
 80b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 80e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 812:	75 07                	jne    81b <morecore+0x38>
    return 0;
 814:	b8 00 00 00 00       	mov    $0x0,%eax
 819:	eb 26                	jmp    841 <morecore+0x5e>
  hp = (Header*)p;
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	8b 55 08             	mov    0x8(%ebp),%edx
 827:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	83 c0 08             	add    $0x8,%eax
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	50                   	push   %eax
 834:	e8 c8 fe ff ff       	call   701 <free>
 839:	83 c4 10             	add    $0x10,%esp
  return freep;
 83c:	a1 08 0c 00 00       	mov    0xc08,%eax
}
 841:	c9                   	leave  
 842:	c3                   	ret    

00000843 <malloc>:

void*
malloc(uint nbytes)
{
 843:	55                   	push   %ebp
 844:	89 e5                	mov    %esp,%ebp
 846:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 849:	8b 45 08             	mov    0x8(%ebp),%eax
 84c:	83 c0 07             	add    $0x7,%eax
 84f:	c1 e8 03             	shr    $0x3,%eax
 852:	83 c0 01             	add    $0x1,%eax
 855:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 858:	a1 08 0c 00 00       	mov    0xc08,%eax
 85d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 860:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 864:	75 23                	jne    889 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 866:	c7 45 f0 00 0c 00 00 	movl   $0xc00,-0x10(%ebp)
 86d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 870:	a3 08 0c 00 00       	mov    %eax,0xc08
 875:	a1 08 0c 00 00       	mov    0xc08,%eax
 87a:	a3 00 0c 00 00       	mov    %eax,0xc00
    base.s.size = 0;
 87f:	c7 05 04 0c 00 00 00 	movl   $0x0,0xc04
 886:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 889:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	8b 40 04             	mov    0x4(%eax),%eax
 897:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89a:	72 4d                	jb     8e9 <malloc+0xa6>
      if(p->s.size == nunits)
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8b 40 04             	mov    0x4(%eax),%eax
 8a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a5:	75 0c                	jne    8b3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 10                	mov    (%eax),%edx
 8ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8af:	89 10                	mov    %edx,(%eax)
 8b1:	eb 26                	jmp    8d9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	8b 40 04             	mov    0x4(%eax),%eax
 8b9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8bc:	89 c2                	mov    %eax,%edx
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	c1 e0 03             	shl    $0x3,%eax
 8cd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dc:	a3 08 0c 00 00       	mov    %eax,0xc08
      return (void*)(p + 1);
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	83 c0 08             	add    $0x8,%eax
 8e7:	eb 3b                	jmp    924 <malloc+0xe1>
    }
    if(p == freep)
 8e9:	a1 08 0c 00 00       	mov    0xc08,%eax
 8ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f1:	75 1e                	jne    911 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8f3:	83 ec 0c             	sub    $0xc,%esp
 8f6:	ff 75 ec             	pushl  -0x14(%ebp)
 8f9:	e8 e5 fe ff ff       	call   7e3 <morecore>
 8fe:	83 c4 10             	add    $0x10,%esp
 901:	89 45 f4             	mov    %eax,-0xc(%ebp)
 904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 908:	75 07                	jne    911 <malloc+0xce>
        return 0;
 90a:	b8 00 00 00 00       	mov    $0x0,%eax
 90f:	eb 13                	jmp    924 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	89 45 f0             	mov    %eax,-0x10(%ebp)
 917:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 91f:	e9 6d ff ff ff       	jmp    891 <malloc+0x4e>
  }
}
 924:	c9                   	leave  
 925:	c3                   	ret    
