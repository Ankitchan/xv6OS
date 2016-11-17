
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 e0 0c 00 00       	add    $0xce0,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 e0 0c 00 00       	add    $0xce0,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 d4 09 00 00       	push   $0x9d4
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 e0 0c 00 00       	push   $0xce0
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 8c 03 00 00       	call   42c <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 da 09 00 00       	push   $0x9da
  be:	6a 01                	push   $0x1
  c0:	e8 2a 05 00 00       	call   5ef <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 47 03 00 00       	call   414 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 ea 09 00 00       	push   $0x9ea
  e1:	6a 01                	push   $0x1
  e3:	e8 07 05 00 00       	call   5ef <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 f7 09 00 00       	push   $0x9f7
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 f6 02 00 00       	call   414 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 0e 03 00 00       	call   454 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 f8 09 00 00       	push   $0x9f8
 16c:	6a 01                	push   $0x1
 16e:	e8 7c 04 00 00       	call   5ef <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 99 02 00 00       	call   414 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 96 02 00 00       	call   43c <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
  }
  exit();
 1b8:	e8 57 02 00 00       	call   414 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 08             	mov    %edx,0x8(%ebp)
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	pushl  0xc(%ebp)
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 47 01 00 00       	call   42c <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b3                	jl     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
      break;
 324:	90                   	nop
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	pushl  0x8(%ebp)
 343:	e8 0c 01 00 00       	call   454 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	pushl  0xc(%ebp)
 361:	ff 75 f4             	pushl  -0xc(%ebp)
 364:	e8 03 01 00 00       	call   46c <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	pushl  -0xc(%ebp)
 375:	e8 c2 00 00 00       	call   43c <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e6:	8d 50 01             	lea    0x1(%eax),%edx
 3e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ef:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40c:	b8 01 00 00 00       	mov    $0x1,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <exit>:
SYSCALL(exit)
 414:	b8 02 00 00 00       	mov    $0x2,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <wait>:
SYSCALL(wait)
 41c:	b8 03 00 00 00       	mov    $0x3,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <pipe>:
SYSCALL(pipe)
 424:	b8 04 00 00 00       	mov    $0x4,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <read>:
SYSCALL(read)
 42c:	b8 05 00 00 00       	mov    $0x5,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <write>:
SYSCALL(write)
 434:	b8 10 00 00 00       	mov    $0x10,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <close>:
SYSCALL(close)
 43c:	b8 15 00 00 00       	mov    $0x15,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <kill>:
SYSCALL(kill)
 444:	b8 06 00 00 00       	mov    $0x6,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <exec>:
SYSCALL(exec)
 44c:	b8 07 00 00 00       	mov    $0x7,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <open>:
SYSCALL(open)
 454:	b8 0f 00 00 00       	mov    $0xf,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <mknod>:
SYSCALL(mknod)
 45c:	b8 11 00 00 00       	mov    $0x11,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <unlink>:
SYSCALL(unlink)
 464:	b8 12 00 00 00       	mov    $0x12,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <fstat>:
SYSCALL(fstat)
 46c:	b8 08 00 00 00       	mov    $0x8,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <link>:
SYSCALL(link)
 474:	b8 13 00 00 00       	mov    $0x13,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <mkdir>:
SYSCALL(mkdir)
 47c:	b8 14 00 00 00       	mov    $0x14,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <chdir>:
SYSCALL(chdir)
 484:	b8 09 00 00 00       	mov    $0x9,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <dup>:
SYSCALL(dup)
 48c:	b8 0a 00 00 00       	mov    $0xa,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <getpid>:
SYSCALL(getpid)
 494:	b8 0b 00 00 00       	mov    $0xb,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <sbrk>:
SYSCALL(sbrk)
 49c:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sleep>:
SYSCALL(sleep)
 4a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <uptime>:
SYSCALL(uptime)
 4ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <gettime>:
SYSCALL(gettime)
 4b4:	b8 16 00 00 00       	mov    $0x16,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <settickets>:
SYSCALL(settickets)
 4bc:	b8 17 00 00 00       	mov    $0x17,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 18             	sub    $0x18,%esp
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	6a 01                	push   $0x1
 4d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d8:	50                   	push   %eax
 4d9:	ff 75 08             	pushl  0x8(%ebp)
 4dc:	e8 53 ff ff ff       	call   434 <write>
 4e1:	83 c4 10             	add    $0x10,%esp
}
 4e4:	90                   	nop
 4e5:	c9                   	leave  
 4e6:	c3                   	ret    

000004e7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e7:	55                   	push   %ebp
 4e8:	89 e5                	mov    %esp,%ebp
 4ea:	53                   	push   %ebx
 4eb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f9:	74 17                	je     512 <printint+0x2b>
 4fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4ff:	79 11                	jns    512 <printint+0x2b>
    neg = 1;
 501:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 508:	8b 45 0c             	mov    0xc(%ebp),%eax
 50b:	f7 d8                	neg    %eax
 50d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 510:	eb 06                	jmp    518 <printint+0x31>
  } else {
    x = xx;
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 518:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 51f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 522:	8d 41 01             	lea    0x1(%ecx),%eax
 525:	89 45 f4             	mov    %eax,-0xc(%ebp)
 528:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52e:	ba 00 00 00 00       	mov    $0x0,%edx
 533:	f7 f3                	div    %ebx
 535:	89 d0                	mov    %edx,%eax
 537:	0f b6 80 a0 0c 00 00 	movzbl 0xca0(%eax),%eax
 53e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 542:	8b 5d 10             	mov    0x10(%ebp),%ebx
 545:	8b 45 ec             	mov    -0x14(%ebp),%eax
 548:	ba 00 00 00 00       	mov    $0x0,%edx
 54d:	f7 f3                	div    %ebx
 54f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 556:	75 c7                	jne    51f <printint+0x38>
  if(neg)
 558:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55c:	74 2d                	je     58b <printint+0xa4>
    buf[i++] = '-';
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	8d 50 01             	lea    0x1(%eax),%edx
 564:	89 55 f4             	mov    %edx,-0xc(%ebp)
 567:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 56c:	eb 1d                	jmp    58b <printint+0xa4>
    putc(fd, buf[i]);
 56e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 571:	8b 45 f4             	mov    -0xc(%ebp),%eax
 574:	01 d0                	add    %edx,%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	83 ec 08             	sub    $0x8,%esp
 57f:	50                   	push   %eax
 580:	ff 75 08             	pushl  0x8(%ebp)
 583:	e8 3c ff ff ff       	call   4c4 <putc>
 588:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 58b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 58f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 593:	79 d9                	jns    56e <printint+0x87>
}
 595:	90                   	nop
 596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 599:	c9                   	leave  
 59a:	c3                   	ret    

0000059b <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 59b:	55                   	push   %ebp
 59c:	89 e5                	mov    %esp,%ebp
 59e:	83 ec 28             	sub    $0x28,%esp
 5a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 5a7:	8b 45 10             	mov    0x10(%ebp),%eax
 5aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 5ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5b3:	89 d0                	mov    %edx,%eax
 5b5:	31 d2                	xor    %edx,%edx
 5b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 5ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
 5bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 5c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c4:	74 13                	je     5d9 <printlong+0x3e>
 5c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c9:	6a 00                	push   $0x0
 5cb:	6a 10                	push   $0x10
 5cd:	50                   	push   %eax
 5ce:	ff 75 08             	pushl  0x8(%ebp)
 5d1:	e8 11 ff ff ff       	call   4e7 <printint>
 5d6:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 5d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5dc:	6a 00                	push   $0x0
 5de:	6a 10                	push   $0x10
 5e0:	50                   	push   %eax
 5e1:	ff 75 08             	pushl  0x8(%ebp)
 5e4:	e8 fe fe ff ff       	call   4e7 <printint>
 5e9:	83 c4 10             	add    $0x10,%esp
}
 5ec:	90                   	nop
 5ed:	c9                   	leave  
 5ee:	c3                   	ret    

000005ef <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5fc:	8d 45 0c             	lea    0xc(%ebp),%eax
 5ff:	83 c0 04             	add    $0x4,%eax
 602:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 605:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 60c:	e9 88 01 00 00       	jmp    799 <printf+0x1aa>
    c = fmt[i] & 0xff;
 611:	8b 55 0c             	mov    0xc(%ebp),%edx
 614:	8b 45 f0             	mov    -0x10(%ebp),%eax
 617:	01 d0                	add    %edx,%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	25 ff 00 00 00       	and    $0xff,%eax
 624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 627:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 62b:	75 2c                	jne    659 <printf+0x6a>
      if(c == '%'){
 62d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 631:	75 0c                	jne    63f <printf+0x50>
        state = '%';
 633:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 63a:	e9 56 01 00 00       	jmp    795 <printf+0x1a6>
      } else {
        putc(fd, c);
 63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	83 ec 08             	sub    $0x8,%esp
 648:	50                   	push   %eax
 649:	ff 75 08             	pushl  0x8(%ebp)
 64c:	e8 73 fe ff ff       	call   4c4 <putc>
 651:	83 c4 10             	add    $0x10,%esp
 654:	e9 3c 01 00 00       	jmp    795 <printf+0x1a6>
      }
    } else if(state == '%'){
 659:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 65d:	0f 85 32 01 00 00    	jne    795 <printf+0x1a6>
      if(c == 'd'){
 663:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 667:	75 1e                	jne    687 <printf+0x98>
        printint(fd, *ap, 10, 1);
 669:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	6a 01                	push   $0x1
 670:	6a 0a                	push   $0xa
 672:	50                   	push   %eax
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 6c fe ff ff       	call   4e7 <printint>
 67b:	83 c4 10             	add    $0x10,%esp
        ap++;
 67e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 682:	e9 07 01 00 00       	jmp    78e <printf+0x19f>
      } else if(c == 'l') {
 687:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 68b:	75 29                	jne    6b6 <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 68d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 690:	8b 50 04             	mov    0x4(%eax),%edx
 693:	8b 00                	mov    (%eax),%eax
 695:	83 ec 0c             	sub    $0xc,%esp
 698:	6a 00                	push   $0x0
 69a:	6a 0a                	push   $0xa
 69c:	52                   	push   %edx
 69d:	50                   	push   %eax
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 f5 fe ff ff       	call   59b <printlong>
 6a6:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 6a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 6ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b1:	e9 d8 00 00 00       	jmp    78e <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 6b6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6ba:	74 06                	je     6c2 <printf+0xd3>
 6bc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6c0:	75 1e                	jne    6e0 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 6c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	6a 00                	push   $0x0
 6c9:	6a 10                	push   $0x10
 6cb:	50                   	push   %eax
 6cc:	ff 75 08             	pushl  0x8(%ebp)
 6cf:	e8 13 fe ff ff       	call   4e7 <printint>
 6d4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6db:	e9 ae 00 00 00       	jmp    78e <printf+0x19f>
      } else if(c == 's'){
 6e0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6e4:	75 43                	jne    729 <printf+0x13a>
        s = (char*)*ap;
 6e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f6:	75 25                	jne    71d <printf+0x12e>
          s = "(null)";
 6f8:	c7 45 f4 0c 0a 00 00 	movl   $0xa0c,-0xc(%ebp)
        while(*s != 0){
 6ff:	eb 1c                	jmp    71d <printf+0x12e>
          putc(fd, *s);
 701:	8b 45 f4             	mov    -0xc(%ebp),%eax
 704:	0f b6 00             	movzbl (%eax),%eax
 707:	0f be c0             	movsbl %al,%eax
 70a:	83 ec 08             	sub    $0x8,%esp
 70d:	50                   	push   %eax
 70e:	ff 75 08             	pushl  0x8(%ebp)
 711:	e8 ae fd ff ff       	call   4c4 <putc>
 716:	83 c4 10             	add    $0x10,%esp
          s++;
 719:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 71d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 720:	0f b6 00             	movzbl (%eax),%eax
 723:	84 c0                	test   %al,%al
 725:	75 da                	jne    701 <printf+0x112>
 727:	eb 65                	jmp    78e <printf+0x19f>
        }
      } else if(c == 'c'){
 729:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 72d:	75 1d                	jne    74c <printf+0x15d>
        putc(fd, *ap);
 72f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	0f be c0             	movsbl %al,%eax
 737:	83 ec 08             	sub    $0x8,%esp
 73a:	50                   	push   %eax
 73b:	ff 75 08             	pushl  0x8(%ebp)
 73e:	e8 81 fd ff ff       	call   4c4 <putc>
 743:	83 c4 10             	add    $0x10,%esp
        ap++;
 746:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74a:	eb 42                	jmp    78e <printf+0x19f>
      } else if(c == '%'){
 74c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 750:	75 17                	jne    769 <printf+0x17a>
        putc(fd, c);
 752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 755:	0f be c0             	movsbl %al,%eax
 758:	83 ec 08             	sub    $0x8,%esp
 75b:	50                   	push   %eax
 75c:	ff 75 08             	pushl  0x8(%ebp)
 75f:	e8 60 fd ff ff       	call   4c4 <putc>
 764:	83 c4 10             	add    $0x10,%esp
 767:	eb 25                	jmp    78e <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 769:	83 ec 08             	sub    $0x8,%esp
 76c:	6a 25                	push   $0x25
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 4e fd ff ff       	call   4c4 <putc>
 776:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77c:	0f be c0             	movsbl %al,%eax
 77f:	83 ec 08             	sub    $0x8,%esp
 782:	50                   	push   %eax
 783:	ff 75 08             	pushl  0x8(%ebp)
 786:	e8 39 fd ff ff       	call   4c4 <putc>
 78b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 78e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 795:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 799:	8b 55 0c             	mov    0xc(%ebp),%edx
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	01 d0                	add    %edx,%eax
 7a1:	0f b6 00             	movzbl (%eax),%eax
 7a4:	84 c0                	test   %al,%al
 7a6:	0f 85 65 fe ff ff    	jne    611 <printf+0x22>
    }
  }
}
 7ac:	90                   	nop
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b5:	8b 45 08             	mov    0x8(%ebp),%eax
 7b8:	83 e8 08             	sub    $0x8,%eax
 7bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 7c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c6:	eb 24                	jmp    7ec <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d0:	77 12                	ja     7e4 <free+0x35>
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d8:	77 24                	ja     7fe <free+0x4f>
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e2:	77 1a                	ja     7fe <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f2:	76 d4                	jbe    7c8 <free+0x19>
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	8b 00                	mov    (%eax),%eax
 7f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fc:	76 ca                	jbe    7c8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	01 c2                	add    %eax,%edx
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	39 c2                	cmp    %eax,%edx
 817:	75 24                	jne    83d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	8b 50 04             	mov    0x4(%eax),%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	01 c2                	add    %eax,%edx
 829:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	8b 10                	mov    (%eax),%edx
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	89 10                	mov    %edx,(%eax)
 83b:	eb 0a                	jmp    847 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	8b 10                	mov    (%eax),%edx
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	01 d0                	add    %edx,%eax
 859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85c:	75 20                	jne    87e <free+0xcf>
    p->s.size += bp->s.size;
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	8b 50 04             	mov    0x4(%eax),%edx
 864:	8b 45 f8             	mov    -0x8(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	01 c2                	add    %eax,%edx
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 872:	8b 45 f8             	mov    -0x8(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
 87c:	eb 08                	jmp    886 <free+0xd7>
  } else
    p->s.ptr = bp;
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	8b 55 f8             	mov    -0x8(%ebp),%edx
 884:	89 10                	mov    %edx,(%eax)
  freep = p;
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	a3 c8 0c 00 00       	mov    %eax,0xcc8
}
 88e:	90                   	nop
 88f:	c9                   	leave  
 890:	c3                   	ret    

00000891 <morecore>:

static Header*
morecore(uint nu)
{
 891:	55                   	push   %ebp
 892:	89 e5                	mov    %esp,%ebp
 894:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 897:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 89e:	77 07                	ja     8a7 <morecore+0x16>
    nu = 4096;
 8a0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	c1 e0 03             	shl    $0x3,%eax
 8ad:	83 ec 0c             	sub    $0xc,%esp
 8b0:	50                   	push   %eax
 8b1:	e8 e6 fb ff ff       	call   49c <sbrk>
 8b6:	83 c4 10             	add    $0x10,%esp
 8b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8bc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c0:	75 07                	jne    8c9 <morecore+0x38>
    return 0;
 8c2:	b8 00 00 00 00       	mov    $0x0,%eax
 8c7:	eb 26                	jmp    8ef <morecore+0x5e>
  hp = (Header*)p;
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	8b 55 08             	mov    0x8(%ebp),%edx
 8d5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8db:	83 c0 08             	add    $0x8,%eax
 8de:	83 ec 0c             	sub    $0xc,%esp
 8e1:	50                   	push   %eax
 8e2:	e8 c8 fe ff ff       	call   7af <free>
 8e7:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ea:	a1 c8 0c 00 00       	mov    0xcc8,%eax
}
 8ef:	c9                   	leave  
 8f0:	c3                   	ret    

000008f1 <malloc>:

void*
malloc(uint nbytes)
{
 8f1:	55                   	push   %ebp
 8f2:	89 e5                	mov    %esp,%ebp
 8f4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	83 c0 07             	add    $0x7,%eax
 8fd:	c1 e8 03             	shr    $0x3,%eax
 900:	83 c0 01             	add    $0x1,%eax
 903:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 906:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 90b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 912:	75 23                	jne    937 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 914:	c7 45 f0 c0 0c 00 00 	movl   $0xcc0,-0x10(%ebp)
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	a3 c8 0c 00 00       	mov    %eax,0xcc8
 923:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 928:	a3 c0 0c 00 00       	mov    %eax,0xcc0
    base.s.size = 0;
 92d:	c7 05 c4 0c 00 00 00 	movl   $0x0,0xcc4
 934:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 937:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93a:	8b 00                	mov    (%eax),%eax
 93c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 948:	72 4d                	jb     997 <malloc+0xa6>
      if(p->s.size == nunits)
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 40 04             	mov    0x4(%eax),%eax
 950:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 953:	75 0c                	jne    961 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 10                	mov    (%eax),%edx
 95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95d:	89 10                	mov    %edx,(%eax)
 95f:	eb 26                	jmp    987 <malloc+0x96>
      else {
        p->s.size -= nunits;
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	8b 40 04             	mov    0x4(%eax),%eax
 967:	2b 45 ec             	sub    -0x14(%ebp),%eax
 96a:	89 c2                	mov    %eax,%edx
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 972:	8b 45 f4             	mov    -0xc(%ebp),%eax
 975:	8b 40 04             	mov    0x4(%eax),%eax
 978:	c1 e0 03             	shl    $0x3,%eax
 97b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	8b 55 ec             	mov    -0x14(%ebp),%edx
 984:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 987:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98a:	a3 c8 0c 00 00       	mov    %eax,0xcc8
      return (void*)(p + 1);
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	83 c0 08             	add    $0x8,%eax
 995:	eb 3b                	jmp    9d2 <malloc+0xe1>
    }
    if(p == freep)
 997:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 99c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 99f:	75 1e                	jne    9bf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9a1:	83 ec 0c             	sub    $0xc,%esp
 9a4:	ff 75 ec             	pushl  -0x14(%ebp)
 9a7:	e8 e5 fe ff ff       	call   891 <morecore>
 9ac:	83 c4 10             	add    $0x10,%esp
 9af:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b6:	75 07                	jne    9bf <malloc+0xce>
        return 0;
 9b8:	b8 00 00 00 00       	mov    $0x0,%eax
 9bd:	eb 13                	jmp    9d2 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	8b 00                	mov    (%eax),%eax
 9ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9cd:	e9 6d ff ff ff       	jmp    93f <malloc+0x4e>
  }
}
 9d2:	c9                   	leave  
 9d3:	c3                   	ret    
